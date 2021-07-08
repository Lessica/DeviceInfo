//# This project is libre, and licenced under the terms of the
//# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENCE, version 3.1,
//# as published by dtf on July 2019. See the COPYING file or
//# https://ph.dtf.wtf/w/wtfpl/#version-3-1 for more details.

import Cocoa

extension Process {
    @discardableResult
    func kill() -> Int32 {
        return Darwin.kill(processIdentifier, SIGKILL)
    }
}

final class TunnelService {
    
    static let shared = TunnelService()
    static let activeTunnelsChangedNotification = Notification.Name(
        "\(String(describing: TunnelService.self)).ActiveTunnelsChangedNotification"
    )
    static let allTunnelsRemovedNotification = Notification.Name(
        "\(String(describing: TunnelService.self)).AllTunnelsRemovedNotification"
    )
    
    static let tunnelsAddedUserInfoKey = "added"
    static let tunnelsRemovedUserInfoKey = "removed"
    
    private static let proxyExecutableURL: URL = Bundle.main.url(
        forResource: "iproxy", withExtension: nil, subdirectory: "tools"
    )!
    
    private var activeTunnels = [Tunnel]()
    internal var allTunnels: [Tunnel] {
        return self.activeTunnels
    }
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(processDidTerminateNotificationReceived(_:)),
            name: Process.didTerminateNotification,
            object: nil
        )
    }
    
    @objc
    private func processDidTerminateNotificationReceived(_ noti: Notification) {
        guard let taskToRemove = noti.object as? Process else {
            return
        }
        if let taskIdx = activeTunnels.firstIndex(where: { $0.process.processIdentifier == taskToRemove.processIdentifier })
        {
            let removedTask = activeTunnels.remove(at: taskIdx)
            NotificationCenter.default.post(
                name: TunnelService.activeTunnelsChangedNotification,
                object: self,
                userInfo: [
                    TunnelService.tunnelsRemovedUserInfoKey: [
                        removedTask,
                    ]
                ]
            )
        }
    }
    
    private func fetchAvailablePort() throws -> UInt16 {
        let socketFD = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
        if socketFD == -1 {
            throw TunnelError.posixError(errCode: errno)
        }
        
        var hints = addrinfo(
            ai_flags: AI_PASSIVE,
            ai_family: AF_INET,
            ai_socktype: SOCK_STREAM,
            ai_protocol: 0,
            ai_addrlen: 0,
            ai_canonname: nil,
            ai_addr: nil,
            ai_next: nil
        );
        
        var addressInfo: UnsafeMutablePointer<addrinfo>? = nil;
        var result = getaddrinfo(nil, "0", &hints, &addressInfo);
        if result != 0 {
            let errno = result
            close(socketFD);
            throw TunnelError.gaiError(errCode: errno)
        }
        
        result = Darwin.bind(socketFD, addressInfo!.pointee.ai_addr, socklen_t(addressInfo!.pointee.ai_addrlen));
        if result == -1 {
            let errno = errno
            close(socketFD);
            throw TunnelError.posixError(errCode: errno)
        }
        
        result = Darwin.listen(socketFD, 1);
        if result == -1 {
            let errno = errno
            close(socketFD);
            throw TunnelError.posixError(errCode: errno)
        }
        
        var addr_in = sockaddr_in();
        addr_in.sin_len = UInt8(MemoryLayout.size(ofValue: addr_in));
        addr_in.sin_family = sa_family_t(AF_INET);
        
        var len = socklen_t(addr_in.sin_len);
        result = withUnsafeMutablePointer(to: &addr_in, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                return Darwin.getsockname(socketFD, $0, &len);
            }
        });
        
        if result != 0 {
            let errno = errno
            Darwin.shutdown(socketFD, SHUT_RDWR);
            close(socketFD);
            throw TunnelError.posixError(errCode: errno)
        }
        
        let port = addr_in.sin_port;
        
        Darwin.shutdown(socketFD, SHUT_RDWR);
        close(socketFD);
        
        return port;
    }
    
    func hasTunnel(udid: String) -> Bool {
        return activeTunnels.firstIndex(where: { $0.udid == udid }) != nil
    }
    
    func getTunnel(udid: String) -> Tunnel? {
        return activeTunnels.first(where: { $0.udid == udid })
    }
    
    func addTunnel(udid: String, description: String? = nil) throws -> Tunnel {
        guard !hasTunnel(udid: udid) else {
            throw TunnelError.alreadyExists(udid: udid)
        }
        let task = Process()
        task.executableURL = TunnelService.proxyExecutableURL
        let srcPort = try fetchAvailablePort()
        task.arguments = [
            "\(srcPort):44",
            "-u",
            udid
        ]
        try task.run()
        let tunnel = Tunnel(
            process: task,
            srcPort: srcPort,
            destPort: 44,
            udid: udid,
            description: description
        )
        self.activeTunnels.append(tunnel)
        NotificationCenter.default.post(
            name: TunnelService.activeTunnelsChangedNotification,
            object: self,
            userInfo: [
                TunnelService.tunnelsAddedUserInfoKey: [
                    tunnel,
                ]
            ]
        )
        return tunnel
    }
    
    @discardableResult
    func removeTunnel(udid: String) -> Tunnel? {
        if let tunnel = activeTunnels.first(where: { $0.udid == udid }) {
            killTunnel(tunnel)
            return tunnel
        }
        return nil
    }
    
    @discardableResult
    func killTunnel(_ tunnel: Tunnel) -> Tunnel {
        tunnel.process.kill()  // send SIGKILL
        return tunnel
    }
    
    @discardableResult
    func terminateTunnel(_ tunnel: Tunnel) -> Tunnel {
        terminateTunnelAsync(
            tunnel,
            queue: .global(qos: .background),
            timeout: 1.0
        ) { _ in
            // killed
        }
        return tunnel
    }
    
    func terminateTunnelAsync(_ tunnel: Tunnel, queue: DispatchQueue, timeout: TimeInterval, completionHandler completion: @escaping (Tunnel) -> Void)
    {
        var isTerminated = false
        
        // set termination handler
        tunnel.process.terminationHandler = { task in
            // set termination flag
            isTerminated = true
            
            // send notification
            NotificationCenter.default.post(
                name: Process.didTerminateNotification,
                object: task
            )
            
            // it must dead
            completion(tunnel)
            tunnel.process.terminationHandler = nil
        }
        
        // send SIGTERM
        tunnel.process.terminate()
        
        queue.asyncAfter(deadline: DispatchTime.now() + timeout) {
            if !isTerminated {
                // send SIGKILL
                tunnel.process.kill()
                
                // wait for exit
                tunnel.process.waitUntilExit()
                
                // it may dead after a while
                isTerminated = true
                
                // it must dead
                completion(tunnel)
                tunnel.process.terminationHandler = nil
            }
        }
    }
    
    func removeAllTunnels() {
        var removedTasks = [Tunnel]()
        let grp = DispatchGroup()
        self.activeTunnels.forEach { [unowned self] tunnel in
            grp.enter()
            
            self.terminateTunnelAsync(
                tunnel,
                queue: .global(qos: .userInitiated),
                timeout: 1.0
            ) { tunnel in
                removedTasks.append(tunnel)
                grp.leave()
            }
        }
        grp.wait()
        NotificationCenter.default.post(
            name: TunnelService.allTunnelsRemovedNotification,
            object: self,
            userInfo: [
                TunnelService.tunnelsRemovedUserInfoKey: removedTasks
            ]
        )
    }
}

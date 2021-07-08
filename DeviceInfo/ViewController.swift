//# This project is libre, and licenced under the terms of the
//# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENCE, version 3.1,
//# as published by dtf on July 2019. See the COPYING file or
//# https://ph.dtf.wtf/w/wtfpl/#version-3-1 for more details.

import Cocoa

extension NSUserInterfaceItemIdentifier {
    
    static let columnProxy = NSUserInterfaceItemIdentifier("ColProxy")
    static let columnKey   = NSUserInterfaceItemIdentifier("ColKey")
    static let columnValue = NSUserInterfaceItemIdentifier("ColValue")
}

final class ViewController: NSViewController {
    
    @IBOutlet var outlineMenu: NSMenu!
    @IBOutlet weak var outlineView: NSOutlineView!
    @IBOutlet weak var refreshButton: NSButton!
    @IBOutlet weak var messageLabel: NSTextField!
    
    @IBOutlet weak var connectMenuItem: NSMenuItem!
    
    private var connectedDevices: [ConnectedDevice]?
    private var expandedState: [String]?

    // 视图控制器视图已加载事件
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageLabel.stringValue = NSLocalizedString("Loading…", comment: "Message")

        // 注册设备列表变化通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(connectedDeviceDidChangeNotificationHandler(_:)),  // 将通知发送到这里
            name: AppDelegate.connectedDevicesDidChangeNotificationName,
            object: nil
        )
        
        // 注册隧道列表清空通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(activeTunnelsChangedNotificationHandler(_:)),  // 将通知发送到这里
            name: TunnelService.allTunnelsRemovedNotification,
            object: nil
        )
        
        // 注册隧道列表变化通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(activeTunnelsChangedNotificationHandler(_:)),  // 将通知发送到这里
            name: TunnelService.activeTunnelsChangedNotification,
            object: nil
        )
    }

    // 设备列表变化通知响应方法
    @objc
    func connectedDeviceDidChangeNotificationHandler(_ noti: Notification) -> Void {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let appDelegate = NSApp.delegate as? AppDelegate {
                
                // 将 Set 转化为数组并排序
                let devices = appDelegate.allDevices.sorted {
                    $0.udid.localizedStandardCompare($1.udid) == .orderedAscending
                }
                
                // 打印当前连接的设备
                debugPrint(devices)
                
                // 保存当前展开状态
                self.saveExpandedState()
                
                // 为表格数据源设置数据
                self.connectedDevices = self.reloadTunnelsIntoConnectedDevices(devices.compactMap({ $0 as? ConnectedDevice }))
                
                // 刷新表格
                self.outlineView.reloadData()
                
                // 恢复展开状态
                self.restoreExpandedState()
                self.outlineView.reloadData()
                
            }
            
            self.refreshButton.isEnabled = true
            self.messageLabel.stringValue = NSLocalizedString("Ready.", comment: "Message")
        }
    }
    
    // 重载隧道列表到设备列表
    private func reloadTunnelsIntoConnectedDevices(_ devices: [ConnectedDevice]) -> [ConnectedDevice] {
        let addedTunnels = TunnelService.shared.allTunnels
        let addedUDIDMapping = Dictionary(uniqueKeysWithValues: addedTunnels.map({ ($0.udid, $0) }))
        devices.forEach({ $0.associatedTunnel = addedUDIDMapping[$0.udid] })
        return devices
    }
    
    // 隧道列表变化、清空通知响应方法
    @objc
    func activeTunnelsChangedNotificationHandler(_ noti: Notification) -> Void {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let tunnelChangedState = noti.userInfo as? [String: [Tunnel]] {
                debugPrint(tunnelChangedState)
                if noti.name == TunnelService.allTunnelsRemovedNotification {
                    self.connectedDevices?.forEach({ $0.associatedTunnel = nil })
                    self.messageLabel.stringValue = NSLocalizedString("All tunnels terminated.", comment: "Message")
                    
                    self.outlineView.reloadData(
                        forRowIndexes: IndexSet(integersIn: 0..<self.outlineView.numberOfRows),
                        columnIndexes: IndexSet(
                            integer: self.outlineView.column(withIdentifier: .columnProxy)
                        )
                    )
                }
                else if noti.name == TunnelService.activeTunnelsChangedNotification {
                    var affectedDevices = [ConnectedDevice]()
                    if let addedTunnels = tunnelChangedState[TunnelService.tunnelsAddedUserInfoKey]
                    {
                        let addedUDIDMapping = Dictionary(uniqueKeysWithValues: addedTunnels.map({ ($0.udid, $0) }))
                        let addedUDIDs = addedUDIDMapping.keys
                        let devices = self.connectedDevices?
                            .filter({ addedUDIDs.contains($0.udid) })
                        affectedDevices.append(contentsOf: devices ?? [])
                        devices?.forEach({ $0.associatedTunnel = addedUDIDMapping[$0.udid] })
                        
                        if addedTunnels.count == 1, let tunnel = addedTunnels.first {
                            self.messageLabel.stringValue = String(format: NSLocalizedString("Tunnel created, src = %d, dest = %d, pid = %d.", comment: "Message"), tunnel.srcPort, tunnel.dstPort, tunnel.process.processIdentifier)
                        }
                    }
                    if let removedTunnels = tunnelChangedState[TunnelService.tunnelsRemovedUserInfoKey]
                    {
                        let removedUDIDs = removedTunnels.map({ $0.udid })
                        let devices = self.connectedDevices?
                            .filter({ removedUDIDs.contains($0.udid) })
                        affectedDevices.append(contentsOf: devices ?? [])
                        devices?.forEach({ $0.associatedTunnel = nil })
                        
                        if removedTunnels.count == 1, let tunnel = removedTunnels.first {
                            self.messageLabel.stringValue = String(format: NSLocalizedString("Tunnel terminated, pid = %d (status = %d).", comment: "Message"), tunnel.process.processIdentifier, tunnel.process.terminationStatus)
                        }
                    }
                    self.outlineView.reloadData(
                        forRowIndexes: IndexSet(
                            affectedDevices
                                .compactMap({ self.outlineView.row(forItem: $0) })
                        ),
                        columnIndexes: IndexSet(
                            integer: self.outlineView.column(withIdentifier: .columnProxy)
                        )
                    )
                }
            }
        }
    }
    
    
    // 点击刷新按钮
    @IBAction func refreshButtonTapped(_ sender: NSButton) {
        (NSApp.delegate as? AppDelegate)?.reloadDevices()
        self.messageLabel.stringValue = NSLocalizedString("Reload device list…", comment: "Message")
        sender.isEnabled = false
    }

}

extension ViewController: NSOutlineViewDataSource, NSOutlineViewDelegate {
    
    // 保存展开状态
    func saveExpandedState() {
        self.expandedState = self.connectedDevices?
            .filter({ outlineView.isItemExpanded($0) })
            .compactMap({ self.outlineView(self.outlineView, persistentObjectForItem: $0) as? String })
    }
    
    // 恢复展开状态
    func restoreExpandedState() {
        if let state = expandedState {
            state.compactMap({ self.outlineView(self.outlineView, itemForPersistentObject: $0) as? ConnectedDevice })
                .forEach({ self.outlineView.expandItem($0) })
            self.expandedState = nil
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, persistentObjectForItem item: Any?) -> Any? {
        if let item = item as? ConnectedDevice {
            return item.udid
        }
        return nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, itemForPersistentObject object: Any) -> Any? {
        if let object = object as? String {
            return self.connectedDevices?.first(where: { $0.udid == object })
        }
        return nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            // 顶层元素数量
            return self.connectedDevices?.count ?? 0
        } else if let item = item as? ConnectedDevice {
            // 设备信息条目数
            return item.aggregatedRecords?.count ?? 0
        }
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil {
            return self.connectedDevices![index]
        } else if let item = item as? ConnectedDevice {
            return item.aggregatedRecords![index]
        }
        fatalError("Not implemented")
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if item is ConnectedDevice {
            return true
        }
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        if tableColumn?.identifier == .columnKey {
            if let item = item as? ConnectedDevice {
                return NSLocalizedString(item.name ?? "[Locked]", tableName: "RecordKeys", bundle: .main, comment: "ConnectedDevice #bc-ignore!")
            } else if let item = item as? AggregatedRecord {
                return NSLocalizedString("\(item.key)", tableName: "RecordKeys", bundle: .main, comment: "ConnectedDevice #bc-ignore!")
            }
        } else if tableColumn?.identifier == .columnValue {
            if let item = item as? ConnectedDevice {
                return item.udid
            } else if let item = item as? AggregatedRecord {
                return item.transformedValue
            }
        } else if tableColumn?.identifier == .columnProxy {
            if let item = item as? ConnectedDevice {
                return item.associatedTunnel == nil
                    ? NSLocalizedString("Connect", comment: "ConnectedDevice")
                    : String(format: NSLocalizedString("Disconnect: %d", comment: "ConnectedDevice"), item.associatedTunnel!.srcPort)
            } else if item is AggregatedRecord {
                return nil
            }
        }
        return nil
    }
    
}

extension ViewController: NSMenuItemValidation, NSMenuDelegate {
    
    private var actionSelectedRowIndexes: IndexSet {
        (outlineView.clickedRow >= 0 && !outlineView.selectedRowIndexes.contains(outlineView.clickedRow))
            ? IndexSet(integer: outlineView.clickedRow)
            : IndexSet(outlineView.selectedRowIndexes)
    }
    
    private var selectedConnectedDevice: ConnectedDevice? {
        if let selectedIndex = actionSelectedRowIndexes.first, selectedIndex < self.connectedDevices?.count ?? 0
        {
            return self.connectedDevices?[selectedIndex]
        }
        return nil
    }
    
    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        if menuItem.action == #selector(copyKey(_:)) || menuItem.action == #selector(copy(_:))
        {
            return !actionSelectedRowIndexes.isEmpty
        }
        else if menuItem.action == #selector(connectOrDisconnect(_:)) {
            return self.selectedConnectedDevice != nil
        }
        return false
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        if menu == self.outlineMenu {
            if let device = self.selectedConnectedDevice {
                if device.associatedTunnel != nil {
                    self.connectMenuItem.title = NSLocalizedString("Disconnect…", comment: "ConnectMenuItem")
                } else {
                    self.connectMenuItem.title = NSLocalizedString("Connect…", comment: "ConnectMenuItem")
                }
            } else {
                self.connectMenuItem.title = NSLocalizedString("Connect…", comment: "ConnectMenuItem")
            }
        }
    }
    
    // 写入剪贴板
    func writeToPasteboard(_ string: String) {
        NSPasteboard.general.declareTypes([.string], owner: nil)
        NSPasteboard.general.setString(string, forType: .string)
        self.messageLabel.stringValue = NSLocalizedString("Copied to pasteboard.", comment: "Message")
    }
    
    // 菜单项动作：拷贝值到剪贴板
    @IBAction @objc
    func copy(_ sender: Any) {
        if let clickedRow = actionSelectedRowIndexes.first {
            let item = outlineView.item(atRow: clickedRow)
            if let item = item as? ConnectedDevice {
                writeToPasteboard(item.udid)
            } else if let item = item as? AggregatedRecord {
                writeToPasteboard(item.transformedValue)
            }
        }
    }
    
    // 菜单项动作：拷贝名称到剪贴板
    @IBAction @objc
    func copyKey(_ sender: Any) {
        if let clickedRow = actionSelectedRowIndexes.first {
            let item = outlineView.item(atRow: clickedRow)
            if let item = item as? ConnectedDevice, let itemName = item.name {
                writeToPasteboard(itemName)
            } else if let item = item as? AggregatedRecord {
                writeToPasteboard(item.key)
            }
        }
    }
    
    // 按钮动作：手动建立或关闭隧道
    @IBAction @objc
    func connectOrDisconnect(_ sender: Any) {
        guard self.refreshButton.isEnabled else { return }
        var clickedRow = actionSelectedRowIndexes.first ?? -1
        if let view = sender as? NSButton {
            clickedRow = outlineView.row(for: view)
        }
        if clickedRow >= 0 {
            let item = outlineView.item(atRow: clickedRow)
            if let item = item as? ConnectedDevice {
                if TunnelService.shared.hasTunnel(udid: item.udid) {
                    // disconnect
                    _ = TunnelService.shared.removeTunnel(udid: item.udid)
                } else {
                    // connect
                    do {
                        self.messageLabel.stringValue = String(format: NSLocalizedString("Create tunnel to %@…", comment: "Message"), item.udid)
                        _ = try TunnelService.shared.addTunnel(
                            udid: item.udid,
                            description: NSLocalizedString(item.name ?? "[Locked]", tableName: "RecordKeys", bundle: .main, comment: "ConnectedDevice #bc-ignore!")
                        )
                    } catch {
                        self.messageLabel.stringValue = error.localizedDescription
                        presentError(error)
                    }
                }
            }
        }
    }
}


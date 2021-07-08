//# This project is libre, and licenced under the terms of the
//# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENCE, version 3.1,
//# as published by dtf on July 2019. See the COPYING file or
//# https://ph.dtf.wtf/w/wtfpl/#version-3-1 for more details.

import Foundation

struct Tunnel: Hashable, Equatable {
    internal init(process: Process, srcPort: UInt16, destPort: UInt16, udid: String, description: String?) {
        self.process = process
        self.srcPort = srcPort
        self.dstPort = destPort
        self.udid = udid
        self.description = description
    }    
    
    let process: Process
    let srcPort: UInt16
    let dstPort: UInt16
    let udid: String
    let description: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(srcPort)
        hasher.combine(dstPort)
        hasher.combine(udid)
    }
    
    static func == (lhs: Tunnel, rhs: Tunnel) -> Bool {
        return lhs.srcPort == rhs.srcPort && lhs.dstPort == rhs.dstPort && lhs.udid == rhs.udid
    }
}

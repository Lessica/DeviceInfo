//# This project is libre, and licenced under the terms of the
//# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENCE, version 3.1,
//# as published by dtf on July 2019. See the COPYING file or
//# https://ph.dtf.wtf/w/wtfpl/#version-3-1 for more details.

import Foundation

enum ConnectionType: String {
    
    case usbmuxd
    case network  // unused
}

class Device: Hashable, Equatable {
    
    let connectionType: ConnectionType
    let udid: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(connectionType)
        hasher.combine(udid)
    }
    
    static func == (lhs: Device, rhs: Device) -> Bool {
        lhs.udid == rhs.udid && lhs.connectionType == rhs.connectionType
    }
    
    internal init?(connectionType: ConnectionType, udid: String) {
        self.connectionType = connectionType
        self.udid = udid
    }
}

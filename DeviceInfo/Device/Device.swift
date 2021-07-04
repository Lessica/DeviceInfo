//
//  Device.swift
//  DeviceInfo
//
//  Created by Rachel on 2021/7/3.
//

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

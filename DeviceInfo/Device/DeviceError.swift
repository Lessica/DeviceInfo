//
//  DeviceError.swift
//  DeviceInfo
//
//  Created by Rachel on 2021/7/3.
//

import Foundation

enum DeviceError: CustomNSError, LocalizedError {
    
    case canNotConnectToLockdownd(err: Int)
    
    var errorCode: Int {
        switch self {
        case .canNotConnectToLockdownd:
            return 601
        }
    }
    
    var failureReason: String? {
        switch self {
        case .canNotConnectToLockdownd(let err):
            return String(format: NSLocalizedString("Could not connect to lockdownd (%d)", comment: "DeviceError"), err)
        }
    }
}

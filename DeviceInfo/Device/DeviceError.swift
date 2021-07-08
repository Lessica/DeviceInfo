//# This project is libre, and licenced under the terms of the
//# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENCE, version 3.1,
//# as published by dtf on July 2019. See the COPYING file or
//# https://ph.dtf.wtf/w/wtfpl/#version-3-1 for more details.

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

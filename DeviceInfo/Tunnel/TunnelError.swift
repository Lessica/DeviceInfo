//# This project is libre, and licenced under the terms of the
//# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENCE, version 3.1,
//# as published by dtf on July 2019. See the COPYING file or
//# https://ph.dtf.wtf/w/wtfpl/#version-3-1 for more details.

import Foundation

enum TunnelError: CustomNSError, LocalizedError {
    
    case alreadyExists(udid: String)
    case posixError(errCode: Int32)
    case gaiError(errCode: Int32)
    
    var errorCode: Int {
        switch self {
        case .alreadyExists:
            return 400
        case .posixError(let errCode):
            return Int(errCode)
        case .gaiError(let errCode):
            return Int(errCode)
        }
    }
    
    var failureReason: String? {
        switch self {
        case .alreadyExists(let udid):
            return String(format: NSLocalizedString("Tunnel for \"%@\" already exists.", comment: "TunnelError"), udid)
        case .posixError(let errCode):
            return String(format: NSLocalizedString("%s (%d)", comment: "TunnelError"), strerror(errCode), errCode)
        case .gaiError(let errCode):
            if errCode == EAI_SYSTEM {
                return String(format: NSLocalizedString("%s (%d)", comment: "TunnelError"), strerror(errno), errno)
            }
            return String(format: NSLocalizedString("%s (%d)", comment: "TunnelError"), gai_strerror(errCode), errCode)
        }
    }
}

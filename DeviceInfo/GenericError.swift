//
//  GenericError.swift
//  DeviceInfo
//
//  Created by Rachel on 2021/7/3.
//

import Foundation

enum GenericError: CustomNSError, LocalizedError {
    case notRegularFile(url: URL)
    case notDirectory(url: URL)
    case notPackage(url: URL)
    
    var errorCode: Int {
        switch self {
        case .notRegularFile:
            return 501
        case .notDirectory:
            return 502
        case .notPackage:
            return 503
        }
    }
    
    var failureReason: String? {
        switch self {
        case let .notRegularFile(url):
            return String(format: NSLocalizedString("Not a regular file: \"%@\".", comment: "GenericError"), url.path)
        case let .notDirectory(url):
            return String(format: NSLocalizedString("Not a directory: \"%@\".", comment: "GenericError"), url.path)
        case let .notPackage(url):
            return String(format: NSLocalizedString("Not a package: \"%@\".", comment: "GenericError"), url.path)
        }
    }
}

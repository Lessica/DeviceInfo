//
//  RecordTransformer.swift
//  DeviceInfo
//
//  Created by Rachel on 2021/7/4.
//

import Foundation

class RecordTransformer {
    
    static let uppercased = UppercasedRecordTransformer()
    static let lowercased = LowercasedRecordTransformer()
    static let timestamp = TimestampTransformer()
    
    func transform(value: String) -> String {
        fatalError("Do not use this abstract class")
    }
}

class UppercasedRecordTransformer: RecordTransformer {
    
    override func transform(value: String) -> String {
        return value.uppercased()
    }
}

class LowercasedRecordTransformer: RecordTransformer {
    
    override func transform(value: String) -> String {
        return value.lowercased()
    }
}

class TimestampTransformer: RecordTransformer {
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    override func transform(value: String) -> String {
        return TimestampTransformer.formatter.string(from: Date(timeIntervalSince1970: TimeInterval(value) ?? 0))
    }
}

//
//  TimestampTransformer.swift
//  DeviceInfo
//
//  Created by Rachel on 2021/7/5.
//

import Foundation

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

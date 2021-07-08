//# This project is libre, and licenced under the terms of the
//# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENCE, version 3.1,
//# as published by dtf on July 2019. See the COPYING file or
//# https://ph.dtf.wtf/w/wtfpl/#version-3-1 for more details.

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

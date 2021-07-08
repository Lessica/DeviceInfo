//# This project is libre, and licenced under the terms of the
//# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENCE, version 3.1,
//# as published by dtf on July 2019. See the COPYING file or
//# https://ph.dtf.wtf/w/wtfpl/#version-3-1 for more details.

import Foundation

class RecordTransformer {
    
    static let uppercased = UppercasedRecordTransformer()
    static let lowercased = LowercasedRecordTransformer()
    static let timestamp = TimestampTransformer()
    static let hardwareModel = HardwareModelTransformer()
    static let cpuModel = CPUModelTransformer()
    
    func transform(value: String) -> String {
        fatalError("Do not use this abstract class")
    }
}

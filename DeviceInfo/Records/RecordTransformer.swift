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
    static let hardwareModel = HardwareModelTransformer()
    static let cpuModel = CPUModelTransformer()
    
    func transform(value: String) -> String {
        fatalError("Do not use this abstract class")
    }
}

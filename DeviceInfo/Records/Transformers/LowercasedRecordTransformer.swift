//
//  LowercasedRecordTransformer.swift
//  DeviceInfo
//
//  Created by Rachel on 2021/7/5.
//

import Foundation

class LowercasedRecordTransformer: RecordTransformer {
    
    override func transform(value: String) -> String {
        return value.lowercased()
    }
}

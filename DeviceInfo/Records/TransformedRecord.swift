//
//  TransformedRecord.swift
//  DeviceInfo
//
//  Created by Rachel on 2021/7/4.
//

import Foundation

class TransformedRecord: FilledRecord {
    internal init(domain: String?, key: String, value: String, transformedValue: String, transformer: RecordTransformer? = nil) {
        self.transformedValue = transformedValue
        super.init(domain: domain, key: key, value: value, transformer: transformer)
    }
    
    internal init(record: FilledRecord) {
        self.transformedValue = record.transformer?.transform(value: record.value) ?? record.value
        super.init(record: record, value: record.value)
    }
    
    let transformedValue: String
}

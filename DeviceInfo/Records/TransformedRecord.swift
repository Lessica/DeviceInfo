//
//  TransformedRecord.swift
//  DeviceInfo
//
//  Created by Rachel on 2021/7/4.
//

import Foundation

class TransformedRecord: FilledRecord {
    
    internal init(domain: String?, key: String, value: String, transformedValue: String, transformers: [RecordTransformer]? = nil) {
        self.transformedValue = transformedValue
        super.init(domain: domain, key: key, value: value, transformers: transformers)
    }
    
    internal init(record: FilledRecord) {
        var transformedValue = record.value
        record.transformers?.forEach({ transformedValue = $0.transform(value: transformedValue) })
        self.transformedValue = transformedValue
        super.init(record: record, value: record.value)
    }
    
    let transformedValue: String
}

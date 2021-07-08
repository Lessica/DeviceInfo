//
//  FilledRecord.swift
//  DeviceInfo
//
//  Created by Rachel on 2021/7/3.
//

import Foundation

class FilledRecord: Record {
    
    internal init(domain: String?, key: String, value: String, transformers: [RecordTransformer]? = nil) {
        self.value = value
        super.init(domain: domain, key: key, transformers: transformers)
    }
    
    internal init(record: Record, value: String) {
        self.value = value
        super.init(domain: record.domain, key: record.key, transformers: record.transformers)
    }
    
    let value: String
}

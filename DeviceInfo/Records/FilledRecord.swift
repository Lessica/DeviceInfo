//
//  FilledRecord.swift
//  DeviceInfo
//
//  Created by Rachel on 2021/7/3.
//

import Foundation

class FilledRecord: Record {
    internal init(domain: String?, key: String, value: String, transformer: RecordTransformer? = nil) {
        self.value = value
        super.init(domain: domain, key: key, transformer: transformer)
    }
    
    internal init(record: Record, value: String) {
        self.value = value
        super.init(domain: record.domain, key: record.key, transformer: record.transformer)
    }
    
    let value: String
}

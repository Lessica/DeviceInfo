//
//  Record.swift
//  DeviceInfo
//
//  Created by Rachel on 2021/7/3.
//

import Foundation

class Record {
    
    internal init(domain: String?, key: String, transformer: RecordTransformer? = nil) {
        self.domain = domain
        self.key = key
        self.transformer = transformer
    }
    
    let domain: String?
    let key: String
    let transformer: RecordTransformer?
}

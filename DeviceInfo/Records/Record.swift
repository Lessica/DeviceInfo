//
//  Record.swift
//  DeviceInfo
//
//  Created by Rachel on 2021/7/3.
//

import Foundation

class Record {
    
    internal init(domain: String?, key: String, transformers: [RecordTransformer]? = nil) {
        self.domain = domain
        self.key = key
        self.transformers = transformers
    }
    
    let domain: String?
    let key: String
    let transformers: [RecordTransformer]?
}

//# This project is libre, and licenced under the terms of the
//# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENCE, version 3.1,
//# as published by dtf on July 2019. See the COPYING file or
//# https://ph.dtf.wtf/w/wtfpl/#version-3-1 for more details.

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

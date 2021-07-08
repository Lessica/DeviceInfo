//# This project is libre, and licenced under the terms of the
//# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENCE, version 3.1,
//# as published by dtf on July 2019. See the COPYING file or
//# https://ph.dtf.wtf/w/wtfpl/#version-3-1 for more details.

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

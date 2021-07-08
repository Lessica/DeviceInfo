//# This project is libre, and licenced under the terms of the
//# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENCE, version 3.1,
//# as published by dtf on July 2019. See the COPYING file or
//# https://ph.dtf.wtf/w/wtfpl/#version-3-1 for more details.

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

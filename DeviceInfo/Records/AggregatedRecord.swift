//
//  AggregatedRecord.swift
//  DeviceInfo
//
//  Created by Rachel on 2021/7/4.
//

import Foundation

final class AggregatedRecord: TransformedRecord {
    
    internal init(
        transformedRecord: TransformedRecord
    ) {
        self.template = nil
        super.init(
            domain: transformedRecord.domain,
            key: transformedRecord.key,
            value: transformedRecord.value,
            transformedValue: transformedRecord.transformedValue
        )
    }
    
    internal init(
        key: String,
        template: String,
        transformedRecords: [TransformedRecord],
        transformers: [RecordTransformer]? = nil
    ) {
        let template = RecordTemplate(
            template: template,
            data: Dictionary(
                uniqueKeysWithValues:
                    transformedRecords.map({ ($0.key, $0.transformedValue) }) +
                    transformedRecords.map({ ("_" + $0.key, $0.value) })
            )
        )
        self.template = template
        var transformedValue = template.populatedTemplate
        transformers?.forEach({ transformedValue = $0.transform(value: transformedValue) })
        let finalVal = transformedValue
        super.init(
            domain: nil,
            key: key,
            value: finalVal,
            transformedValue: finalVal,
            transformers: transformers
        )
    }
    
    let template: RecordTemplate?
    var associatedTunnel: Tunnel? = nil
}

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
        transformer: RecordTransformer? = nil
    ) {
        let template = RecordTemplate(
            template: template,
            data: Dictionary(uniqueKeysWithValues: transformedRecords.map({ ($0.key, $0.transformedValue) }))
        )
        self.template = template
        let finalVal = transformer?.transform(value: template.populatedTemplate) ?? template.populatedTemplate
        super.init(
            domain: nil,
            key: key,
            value: finalVal,
            transformedValue: finalVal,
            transformer: transformer
        )
    }
    
    let template: RecordTemplate?
}

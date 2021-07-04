//
//  RecordTemplate.swift
//  DeviceInfo
//
//  Created by Rachel on 2021/7/4.
//

import Foundation

@dynamicMemberLookup
struct RecordTemplate {
    var template: String
    private var data: [String: String]
    var populatedTemplate : String { data.reduce(template) { $0.replacingOccurrences(of: "${\($1.key)}", with: $1.value) } }

    init(template: String, data: [String: String] = [:]) {
        self.template = template
        self.data = data
    }
    
    subscript(dynamicMember member: String) -> CustomStringConvertible? {
        get { data[member] }
        set { data[member] = newValue?.description }
    }
    
    subscript(dynamicMember member: String) -> Date {
        get { dateFormatter.date(from: data[member] ?? "") ?? Date(timeIntervalSince1970: 0) }
        set { data[member] = dateFormatter.string(from: newValue) }
    }
    
    let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.calendar = Calendar(identifier: .gregorian)
        
        return formatter
    }()
}

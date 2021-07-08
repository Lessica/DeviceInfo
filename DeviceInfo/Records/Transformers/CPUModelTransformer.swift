//
//  CPUModelTransformer.swift
//  DeviceInfo
//
//  Created by Rachel on 2021/7/5.
//

import Foundation

class CPUModelTransformer: RecordTransformer {
    
    static let modelNameMapping: [String: String] = [
        "S5L8930": "A4",
        "S5L8940": "A5",
        "S5L8942": "A5 Rev A",
        "S5L8945": "A5X",
        "S5L8947": "A5 Rev B",
        "S5L8950": "A6",
        "S5L8955": "A6X",
        "S5L8960": "A7",
        "S5L8965": "A7 Variant",
        "T7000": "A8",
        "T7001": "A8X",
        "S8000": "A9 (Samsung)",
        "S8001": "A9X",
        "S8003": "A9 (TSMC))",
        "T8010": "A10 Fusion",
        "T8011": "A10X Fusion",
        "T8015": "A11 Bionic",
        "T8020": "A12 Bionic",
        "T8027": "A12X Bionic / A12Z Bionic",
        "T8030": "A13 Bionic",
        "T8101": "A14 Bionic",
    ]
    
    override func transform(value: String) -> String {
        return CPUModelTransformer.modelNameMapping[value] ?? NSLocalizedString("Unknown Model", comment: "CPUModelTransformer")
    }
}

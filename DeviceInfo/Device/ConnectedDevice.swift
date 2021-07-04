//
//  ConnectedDevice.swift
//  DeviceInfo
//
//  Created by Rachel on 2021/7/3.
//

import Foundation

final class ConnectedDevice: Device {
    
    private let internalLock: NSLock
    private let internalDevice: idevice_t
    private var lockdowndService: lockdownd_client_t?
    
    override init?(connectionType: ConnectionType, udid: String) {
        var device: idevice_t?
        let err = idevice_new_with_options(&device, udid.cString(using: .utf8), IDEVICE_LOOKUP_USBMUX)
        guard err == IDEVICE_E_SUCCESS else {
            return nil
        }
        self.internalLock = NSLock()
        self.internalDevice = device!
        super.init(connectionType: connectionType, udid: udid)
    }
    
    convenience init?(device: Device) {
        self.init(connectionType: device.connectionType, udid: device.udid)
    }
    
    private func connectToLockdowndIfNecessary() throws {
        self.internalLock.lock()
        if self.lockdowndService != nil {
            self.internalLock.unlock()
            return
        }
        var lockdownd: lockdownd_client_t?
        let err = lockdownd_client_new_with_handshake(internalDevice, &lockdownd, "idevicename")
        guard err == LOCKDOWN_E_SUCCESS else {
            self.internalLock.unlock()
            throw DeviceError.canNotConnectToLockdownd(err: Int(err.rawValue))
        }
        self.lockdowndService = lockdownd
        self.internalLock.unlock()
    }
    
    private func disconnectFromLockdownd() {
        self.internalLock.lock()
        if lockdowndService != nil {
            lockdownd_client_free(lockdowndService)
            lockdowndService = nil
        }
        self.internalLock.unlock()
    }
    
    lazy var name: String? = {
        return try? getName()
    }()
    
    private func getName() throws -> String {
        try self.connectToLockdowndIfNecessary()
        
        self.internalLock.lock()
        var name: UnsafeMutablePointer<CChar>?
        let err = lockdownd_get_device_name(lockdowndService, &name)
        guard err == LOCKDOWN_E_SUCCESS else {
            self.internalLock.unlock()
            throw DeviceError.canNotConnectToLockdownd(err: Int(err.rawValue))
        }
        
        self.internalLock.unlock()
        return String(cString: name!)
    }
    
    private func getRecords() -> [Record] {
        return [
            Record(domain: nil, key: "DeviceClass"),
            Record(domain: nil, key: "SerialNumber"),
            Record(domain: nil, key: "ProductVersion"),
            Record(domain: nil, key: "ProductName"),
            Record(domain: nil, key: "BuildVersion"),
            Record(domain: nil, key: "TimeIntervalSince1970",   transformer: .timestamp),
            Record(domain: nil, key: "InternationalMobileEquipmentIdentity"),
            Record(domain: nil, key: "MobileEquipmentIdentifier"),
            Record(domain: nil, key: "ModelNumber"),
            Record(domain: nil, key: "ProductType"),
            Record(domain: nil, key: "RegionInfo"),
            Record(domain: nil, key: "WiFiAddress",             transformer: .uppercased),
            Record(domain: nil, key: "BluetoothAddress",        transformer: .uppercased),
            Record(domain: nil, key: "EthernetAddress",         transformer: .uppercased),
            Record(domain: nil, key: "DeviceName"),
            Record(domain: nil, key: "HardwarePlatform",        transformer: .uppercased),
            Record(domain: nil, key: "HardwareModel"),
            Record(domain: nil, key: "CPUArchitecture"),
        ]
    }
    
    private func getFilledRecords() throws -> [FilledRecord] {
        try self.connectToLockdowndIfNecessary()
        
        self.internalLock.lock()
        
        var filledRecords = [FilledRecord]()
        for record in getRecords() {
            var plistVal: plist_t?
            
            let err = lockdownd_get_value(
                lockdowndService,
                record.domain,
                record.key,
                &plistVal
            )
            guard err == LOCKDOWN_E_SUCCESS else {
                continue
            }
            
            guard plistVal != nil else {
                continue
            }
            
            let tmPtr = tmpfile()
            plist_print_to_stream(plistVal, tmPtr)
            plist_free(plistVal)
            
            let tmLen = ftell(tmPtr)
            rewind(tmPtr)
            
            var contentPtr = Array<UInt8>(repeating: 0, count: tmLen + 1)
            guard fread(&contentPtr, 1, tmLen, tmPtr) > 0 else {
                fclose(tmPtr)
                continue
            }
            
            fclose(tmPtr)
            let filledRecord = FilledRecord(
                record: record,
                value: String(cString: contentPtr)
                    .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            )
            
            filledRecords.append(filledRecord)
        }
        
        self.internalLock.unlock()
        return filledRecords
    }
    
    private func getTransformedRecords() throws -> [TransformedRecord] {
        let filledRecords = try getFilledRecords()
        return filledRecords.map({ TransformedRecord(record: $0) })
    }
    
    lazy var aggregatedRecords: [AggregatedRecord]? = {
        return try? getAggregatedRecords()
    }()
    
    private func getAggregatedRecords() throws -> [AggregatedRecord] {
        let transformedRecords = try getTransformedRecords()
        return transformedRecords.map({ AggregatedRecord(transformedRecord: $0) })
    }
    
    deinit {
        disconnectFromLockdownd()
        idevice_free(internalDevice)
    }
    
}

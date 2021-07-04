//
//  AppDelegate.swift
//  DeviceInfo
//
//  Created by Rachel on 2021/6/15.
//

import Cocoa

func ideviceEventHandler(_ event: UnsafePointer<idevice_event_t>?, _ userData: UnsafeMutableRawPointer?) -> Void {
    let eventHandler = Unmanaged<AppDelegate>.fromOpaque(userData!).takeUnretainedValue()
    // 只处理 USB 连接的设备
    if let event = event, event.pointee.conn_type == CONNECTION_USBMUXD {
        // 由事件构建 Device 对象
        if let device = Device(
            connectionType: .usbmuxd,
            udid: String(cString: event.pointee.udid)
        ) {
            switch event.pointee.event {
            case IDEVICE_DEVICE_ADD:
                // 添加设备
                if let connectedDevice = ConnectedDevice(device: device) {
                    eventHandler.deviceDidConnect(connectedDevice)
                }
            case IDEVICE_DEVICE_REMOVE:
                // 移除设备
                eventHandler.deviceDidDisconnect(device)
            case IDEVICE_DEVICE_PAIRED:
                // 配对设备
                if let connectedDevice = ConnectedDevice(device: device) {
                    eventHandler.deviceDidPaired(connectedDevice)
                }
            default:
                fatalError("Unknown event type")
            }
        }
    }
}

protocol DeviceEventHandler {
    func deviceDidConnect(_ device: Device)
    func deviceDidDisconnect(_ device: Device)
    func deviceDidPaired(_ device: Device)
}

@main
final class AppDelegate: NSObject, NSApplicationDelegate, DeviceEventHandler {
    
    // 设备列表发生变化时，应用程序内部的通知名称
    static let connectedDevicesDidChangeNotificationName = Notification.Name("AppDelegate.ConnectedDevicesDidChange")
    
    // 已连接的设备
    // Set 容器的特性，决定了它会对其中的 Hashable 对象自动去重
    var allDevices = Set<Device>()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // 应用程序已经启动回调
        
        // 设置打印调试日志开关
        idevice_set_debug_level(1)
        
        // 开始订阅设备事件
        idevice_event_subscribe(ideviceEventHandler(_:_:), UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // 应用程序即将终止回调
        
        // 停止订阅设备事件
        idevice_event_unsubscribe()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // 最后一个窗口关闭后退出应用程序
        return true
    }
    
    func deviceDidConnect(_ device: Device) {
        // 设备已连接
        allDevices.insert(device)
        
        // 发送设备列表变化通知
        NotificationCenter.default.post(name: AppDelegate.connectedDevicesDidChangeNotificationName, object: nil)
    }
    
    func deviceDidDisconnect(_ device: Device) {
        // 设备已断开连接
        allDevices.remove(device)
        
        // 发送设备列表变化通知
        NotificationCenter.default.post(name: AppDelegate.connectedDevicesDidChangeNotificationName, object: nil)
    }
    
    func deviceDidPaired(_ device: Device) {
        // 设备已配对
        allDevices.remove(device)
        allDevices.insert(device)
        
        // 发送设备列表变化通知
        NotificationCenter.default.post(name: AppDelegate.connectedDevicesDidChangeNotificationName, object: nil)
    }
    
    // 重载全部设备
    func reloadDevices() {
        var devicesPtr: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>?
        var deviceCount: Int32 = 0
        let err = idevice_get_device_list(&devicesPtr, &deviceCount)
        guard err == IDEVICE_E_SUCCESS else {
            return
        }
        
        self.allDevices = Set<Device>(
            Array(
                UnsafeBufferPointer(
                    start: devicesPtr,
                    count: Int(deviceCount)
                )
            )
            .compactMap({ $0 })
            .map({ String(cString: $0) })
            .compactMap({ ConnectedDevice(connectionType: .usbmuxd, udid: $0) })
        )
        
        // 发送设备列表变化通知
        NotificationCenter.default.post(name: AppDelegate.connectedDevicesDidChangeNotificationName, object: nil)
    }

}


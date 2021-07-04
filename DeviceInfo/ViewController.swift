//
//  ViewController.swift
//  DeviceInfo
//
//  Created by Rachel on 2021/6/15.
//

import Cocoa

final class ViewController: NSViewController {
    
    @IBOutlet weak var outlineView: NSOutlineView!
    
    private var connectedDevices: [ConnectedDevice]?
    private var expandedState: [String]?

    // 视图控制器视图已加载事件
    override func viewDidLoad() {
        super.viewDidLoad()

        // 注册设备列表变化通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(connectedDeviceDidChangeNotificationHandler(_:)),  // 将通知发送到这里
            name: AppDelegate.connectedDevicesDidChangeNotificationName,
            object: nil
        )
    }

    // 通知响应方法
    @objc func connectedDeviceDidChangeNotificationHandler(_ noti: Notification) -> Void {
        DispatchQueue.main.async { [unowned self] in
            if let appDelegate = NSApp.delegate as? AppDelegate {
                
                // 将 Set 转化为数组并排序
                let devices = appDelegate.allDevices.sorted {
                    $0.udid.localizedStandardCompare($1.udid) == .orderedAscending
                }
                
                // 打印当前连接的设备
                debugPrint(devices)
                
                // 保存当前展开状态
                self.saveExpandedState()
                
                // 为表格数据源设置数据
                self.connectedDevices = devices.compactMap({ $0 as? ConnectedDevice })
                
                // 刷新表格
                self.outlineView.reloadData()
                
                // 恢复展开状态
                self.restoreExpandedState()
                self.outlineView.reloadData()
                
            }
        }
    }
    
    // 点击刷新按钮
    @IBAction func refreshButtonTapped(_ sender: NSButton) {
        (NSApp.delegate as? AppDelegate)?.reloadDevices()
    }

}

extension ViewController: NSOutlineViewDataSource, NSOutlineViewDelegate {
    
    func saveExpandedState() {
        self.expandedState = self.connectedDevices?
            .filter({ outlineView.isItemExpanded($0) })
            .compactMap({ self.outlineView(self.outlineView, persistentObjectForItem: $0) as? String })
    }
    
    func restoreExpandedState() {
        if let state = expandedState {
            state.compactMap({ self.outlineView(self.outlineView, itemForPersistentObject: $0) as? ConnectedDevice })
                .forEach({ self.outlineView.expandItem($0) })
            self.expandedState = nil
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, persistentObjectForItem item: Any?) -> Any? {
        if let item = item as? ConnectedDevice {
            return item.udid
        }
        return nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, itemForPersistentObject object: Any) -> Any? {
        if let object = object as? String {
            return self.connectedDevices?.first(where: { $0.udid == object })
        }
        return nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            // 顶层元素数量
            return self.connectedDevices?.count ?? 0
        } else if let item = item as? ConnectedDevice {
            // 设备信息条目数
            return item.aggregatedRecords?.count ?? 0
        }
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil {
            return self.connectedDevices![index]
        } else if let item = item as? ConnectedDevice {
            return item.aggregatedRecords![index]
        }
        fatalError("Not implemented")
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if item is ConnectedDevice {
            return true
        }
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        if tableColumn?.identifier.rawValue == "ColKey" {
            if let item = item as? ConnectedDevice {
                return item.name ?? NSLocalizedString("[Locked]", comment: "ConnectedDevice")
            } else if let item = item as? AggregatedRecord {
                return item.key
            }
        } else if tableColumn?.identifier.rawValue == "ColValue" {
            if let item = item as? ConnectedDevice {
                return item.udid
            } else if let item = item as? AggregatedRecord {
                return item.transformedValue
            }
        }
        return nil
    }
    
}


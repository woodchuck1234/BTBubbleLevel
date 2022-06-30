//
//  BLEManager.swift
//  DABLETemperatureSensor
//
//  Created by Dejan on 11/02/2017.
//  Copyright © 2017 Dejan. All rights reserved.
//

import Foundation
import CoreBluetooth

private struct BLEConstants {
    //static let TemperatureService = CBUUID(string: "6e400001-b5a3-f393-e0a9-e50e24dcca9e")
    //static let RXCharacteristic = CBUUID(string: "6e400003-b5a3-f393-e0a9-e50e24dcca9e")
    
    static let TemperatureService = CBUUID(string: "6e400001-b5a3-f393-e0a9-e50e24dcca9e")
    static let RXCharacteristic = CBUUID(string: "6e400003-b5a3-f393-e0a9-e50e24dcca9e")
}

private struct Weak<T: AnyObject> {
    weak var object: T?
}

protocol BLEManagable {
    func startScanning()
    func stopScanning()
    
    func addDelegate(_ delegate: BLEManagerDelegate)
    func removeDelegate(_ delegate: BLEManagerDelegate)
    func getData() -> String
    func connected() -> Bool
}

protocol BLEManagerDelegate: AnyObject {
    func bleManagerDidConnect(_ manager: BLEManagable)
    func bleManagerDidDisconnect(_ manager: BLEManagable)
    func bleManager(_ manager: BLEManagable, receivedDataString dataString: String)
}

class BLEManager: NSObject, ObservableObject, BLEManagable {
    func connected() -> Bool {
        if connectedPeripheral != nil {
            return true
        } else {
            return false
        }
    }
    
 
    fileprivate var shouldStartScanning = false
    
    //Used by contentView.swift
    @Published var name = ""

    var rxDataString = ""
    
    private var centralManager: CBCentralManager?
    private var isCentralManagerReady: Bool {
        get {
            guard let centralManager = centralManager else {
                return false
            }
            return centralManager.state != .poweredOff && centralManager.state != .unauthorized && centralManager.state != .unsupported
        }
    }
    
    fileprivate var connectingPeripheral: CBPeripheral?
    fileprivate var connectedPeripheral: CBPeripheral?
    
    fileprivate var delegates: [Weak<AnyObject>] = []
    fileprivate func bleDelegates() -> [BLEManagerDelegate] {
        return delegates.compactMap { $0.object as? BLEManagerDelegate }
    }
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.global(qos: .background))
        startScanning()
    }
    
    func startScanning() {
        print("Start Scanning")
        guard let centralManager = centralManager, isCentralManagerReady == true else {
            return
        }
        
        if centralManager.state != .poweredOn {
            shouldStartScanning = true
        } else {
            shouldStartScanning = false
            centralManager.scanForPeripherals(withServices: [BLEConstants.TemperatureService], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    func stopScanning() {
        shouldStartScanning = false
        centralManager?.stopScan()
    }
     
    func getData() -> String {
        return rxDataString
    }
    
    func addDelegate(_ delegate: BLEManagerDelegate) {
        delegates.append(Weak(object: delegate))
    }
    
    func removeDelegate(_ delegate: BLEManagerDelegate) {
        if let index = delegates.firstIndex(where: { $0.object === delegate }) {
            delegates.remove(at: index)
        }
    }
    
}

// MARK: CBCentralManagerDelegate
extension BLEManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("DidUpdateState")
        if central.state == .poweredOn {
            if self.shouldStartScanning {
                self.startScanning()
            }
        } else {
            self.connectingPeripheral = nil
            if let connectedPeripheral = self.connectedPeripheral {
                central.cancelPeripheralConnection(connectedPeripheral)
            }
            self.shouldStartScanning = true
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("didDiscover")
        self.connectingPeripheral = peripheral
        central.connect(peripheral, options: nil)
        self.stopScanning()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnect")
        self.connectedPeripheral = peripheral
        self.connectingPeripheral = nil
        
        peripheral.discoverServices([BLEConstants.TemperatureService])
        peripheral.delegate = self
        
        self.informDelegatesDidConnect(manager: self)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        self.connectingPeripheral = nil
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.connectedPeripheral = nil
        self.startScanning()
        self.informDelegatesDidDisconnect(manager: self)
    }
}

// MARK: CBPeripheralDelegate
extension BLEManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("didDiscoverServices")
        if let tempService = peripheral.services?.filter({ $0.uuid.uuidString.uppercased() == BLEConstants.TemperatureService.uuidString.uppercased() }).first {
            peripheral.discoverCharacteristics([BLEConstants.RXCharacteristic], for: tempService)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("didDiscoverCharacteristic")
        if let rxCharacteristic = service.characteristics?.filter({ $0.uuid.uuidString.uppercased() == BLEConstants.RXCharacteristic.uuidString.uppercased()}).first {
            peripheral.setNotifyValue(true, for: rxCharacteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        //print("didUpdateValueFor")
        guard let temperatureData = characteristic.value else {
            return
        }
        
        if let dataString = NSString.init(data: temperatureData, encoding: String.Encoding.utf8.rawValue) as String? {
            self.informDelegatesDidReceiveData(manager: self, dataString: dataString)
        }
    }
}

// MARK: Delegate Callbacks
extension BLEManager {
    
    func informDelegatesDidConnect(manager: BLEManager) {
        for delegate in self.bleDelegates() {
            DispatchQueue.main.async {
                delegate.bleManagerDidConnect(manager)
            }
        }
    }
    
    func informDelegatesDidDisconnect(manager: BLEManager) {
        for delegate in self.bleDelegates() {
            DispatchQueue.main.async {
                delegate.bleManagerDidDisconnect(manager)
            }
        }
    }
    
    func informDelegatesDidReceiveData(manager: BLEManager, dataString: String) {
        //print("informDelegateDidReceiveData")
        // put receivedDataString into @published var for view
        self.rxDataString = dataString
        for delegate in self.bleDelegates() {
            DispatchQueue.main.async {
                delegate.bleManager(manager, receivedDataString: dataString)
            }
        }
    }
}



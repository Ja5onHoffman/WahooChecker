//
//  Bluetooth.swift
//  WahooCompare
//
//  Created by Jason Hoffman on 7/13/20.
//  Copyright © 2020 Jason Hoffman. All rights reserved.
//

import SwiftUI
import CoreBluetooth


open class Bluetooth: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    
    @EnvironmentObject var bt: Bluetooth
    
    @Published var names = [String]()
    @Published var peripherals = [CBPeripheral]()
    @Published var deviceList = [Device]()
    
    var centralManager: CBCentralManager!
    let powerMeterServiceCBUUID = CBUUID(string: "0x1818")
    let powerMeasurementCharacteristicCBUUID = CBUUID(string: "0x2A63")
    let wattUnitCBUUID = CBUUID(string: "0x2762")
    var deviceNumber = 0
    
    var p1: CBPeripheral?
    var p2: CBPeripheral?

    @Published var p1Values = PowerArray(size: 100)
    @Published var p2Values = PowerArray(size: 100)
    
    @Published var p1Power = PowerData(value: 0)
    @Published var p2Power = PowerData(value: 0)
    
    @Published var p1Name: String? = "Device 1"
    @Published var p2Name: String? = "Device 2"

    public override init() {
        super.init()
        self.createCentralManager()
    }
    
    struct Device: Identifiable, Hashable {
        let id = UUID()
        let name: String
    }
    
    func createCentralManager() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func scan() {
        if centralManager.state == .poweredOn && !centralManager.isScanning {
                centralManager.scanForPeripherals(withServices: [powerMeterServiceCBUUID], options: nil)
        } else {
            print("Bluetooth is off")
        }
    }
    
    func stopScan() {
        centralManager.stopScan()
        deviceList.removeAll()
        peripherals.removeAll()
    }
    
    func loadDevices() {
        for i in peripherals {
            if let name = i.name {
                    deviceList.append(Device(name: name))
            }
        }
    }
    
    func addPeripheral(_ peripheral: CBPeripheral) {
        if let p = peripherals[0] as CBPeripheral? {
            p1 = p
            p1Name = p.name!
            p1!.delegate = self
        }
        
        if peripherals.count > 1 {
            if let p = peripherals[1] as CBPeripheral? {
                p2 = p
                p2Name = p.name!
                p2!.delegate = self
            }
        }
    }
    
    func connectTo(_ peripheral: CBPeripheral) {
        // Assioma has to be in L only mode vs Dual L/R
        centralManager.connect(peripheral, options: nil)
    }
    
    func disconnect(_ peripheral: CBPeripheral) {
        centralManager.cancelPeripheralConnection(peripheral)
    }
    
    func setDeviceNumber(_ number: Int) {
        self.deviceNumber = number
    }
    
//MARK: CBCentralManagerDelegate
        
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
            print("Update state")
            switch central.state {
              case .unknown:
                print("central.state is .unknown")
              case .resetting:
                print("central.state is .resetting")
              case .unsupported:
                print("central.state is .unsupported")
              case .unauthorized:
                print("central.state is .unauthorized")
              case .poweredOff:
                print("central.state is .poweredOff")
              case .poweredOn:
                print("central.state is .poweredOn")
            @unknown default:
                print("error")
            }
        }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        peripherals.append(peripheral) // Device list uses this
        loadDevices()
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        peripheral.discoverServices(nil)
    }

    
//MARK: CBPeripheralDelegate
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
      guard let services = peripheral.services else { return }

      for service in services {
        print(service)
        peripheral.discoverCharacteristics(nil, for: service)
      }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
          print(characteristic)
          if characteristic.properties.contains(.read) {
            print("\(characteristic.uuid): properties contains .read")
            peripheral.readValue(for: characteristic)

          }
          if characteristic.properties.contains(.notify) {
            print("\(characteristic.uuid): properties contains .notify")
                  peripheral.setNotifyValue(true, for: characteristic)
          }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {

        switch characteristic.uuid {
        case powerMeasurementCharacteristicCBUUID:
            if peripheral.name == p1Name {
                p1Power = powerMeasurement(from: characteristic)
                p1Values.addValue(p1Power)
            } else if peripheral.name == p2Name {
                p2Power = powerMeasurement(from: characteristic)
                p2Values.addValue(p2Power)
            }
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
        
    }
    
    func powerMeasurement(from characteristic: CBCharacteristic) -> PowerData {

        guard let characteristicData = characteristic.value else { return PowerData(value: 0) }
        let byteArray = [UInt8](characteristicData)
        
        // Power comes through in two bytes
        // Above 256 combine to get power
        let msb = byteArray[3]
        let lsb = byteArray[2]
        let pRaw = (Int16(msb) << 8 ) | Int16(lsb)
        let p = PowerData(value: CGFloat(pRaw))
        return p
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let p = peripherals.firstIndex(of: peripheral) {
            peripherals.remove(at: p)
        }

    }
}

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
    
    static let sharedInstance = Bluetooth() 
    
    @Published var names = [String]()
    @Published var peripherals = [CBPeripheral]()

    var centralManager: CBCentralManager!
    let powerMeterServiceCBUUID = CBUUID(string: "0x1818")
    let powerMeasurementCharacteristicCBUUID = CBUUID(string: "0x2A63")
    let wattUnitCBUUID = CBUUID(string: "0x2762")
    
    var p1: CBPeripheral!
    var p2: CBPeripheral!
    var p1Name: String!
    var p2Name: String!
    
    @Published var p1Values = [Float]()
    @Published var p2Values = [Float]()
    
    @Published var p1Power: Int16 = 0
    @Published var p2Power: Int16 = 0

    
    
    public override init() {
        super.init()
        self.createCentralManager()
    }
    
    func createCentralManager() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
        print("Created")
    }
    
    func scan() {
        if centralManager.state == .poweredOn && !centralManager.isScanning {
                centralManager.scanForPeripherals(withServices: [powerMeterCBUUID], options: nil)
        } else {
            print("Bluetooth is off")
        }
    }
    
    func addPeripheral(_ peripheral: CBPeripheral) {
        peripherals.append(peripheral)
        if let p = peripherals.first {
            p1 = p
            p1Name = p.name
            p1.delegate = self
        }
        
        if let p = peripherals[1] as CBPeripheral? {
            p2 = p
            p2Name = p.name
            p2.delegate = self
        }
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
        print(peripheral)
        // Need a way to identify different systems
        peripherals.append(peripheral)
//        if peripheral.name!.contains("CORE") {
//            trainerPeripheral = peripheral
//            centralManager.connect(trainerPeripheral)
//            trainerPeripheral.delegate = self
//        }
//
//        if peripheral.name!.contains("ASSIOMA") {
//            powermeterPeripheral = peripheral
//            centralManager.connect(powermeterPeripheral)
//            powermeterPeripheral.delegate = self
//        }
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        peripheral.discoverServices(nil)
//        powermeterPeripheral.discoverServices(nil)
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
            p1Power = powerMeasurement(from: characteristic)
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
        
    }
    
    func powerMeasurement(from characteristic: CBCharacteristic) -> Int16 {

        guard let characteristicData = characteristic.value else { return -1 }
        let byteArray = [UInt8](characteristicData)
        print(byteArray)
        
        // Power comes through in two bytes
        // Above 256 combine to get power
        let msb = byteArray[3]
        let lsb = byteArray[2]
        let p = (Int16(msb) << 8 ) | Int16(lsb)
        
        return p
    }
}

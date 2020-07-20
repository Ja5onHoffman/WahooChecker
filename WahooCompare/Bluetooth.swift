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
    
    var centralManager: CBCentralManager!
    let powerMeterServiceCBUUID = CBUUID(string: "0x1818")
    let powerMeasurementCharacteristicCBUUID = CBUUID(string: "0x2A63")
    
    var powermeterPeripheral: CBPeripheral!
    var trainerPeripheral: CBPeripheral!
    
    var peripherals = [String]()
    
    public override init() {
        super.init()
        self.createCentralManager()
    }
    
    func createCentralManager() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
        print("Created")
    }
    
    func scan() {
        if centralManager.state == .poweredOn {
                centralManager.scanForPeripherals(withServices: [powerMeterCBUUID], options: nil)
        } else {
            print("Bluetooth is off")
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
        if peripheral.name!.contains("CORE") {
            trainerPeripheral = peripheral
            centralManager.connect(trainerPeripheral)
            trainerPeripheral.delegate = self
        }
        
        if peripheral.name!.contains("ASSIOMA") {
            powermeterPeripheral = peripheral
            centralManager.connect(powermeterPeripheral)
            powermeterPeripheral.delegate = self
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        trainerPeripheral.discoverServices(nil)
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

          print("Unhandled Characteristic UUID: \(characteristic.uuid)")
    }
}

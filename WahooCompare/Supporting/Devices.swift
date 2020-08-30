//
//  Devices.swift
//  WahooCompare
//
//  Created by Jason Hoffman on 8/21/20.
//  Copyright © 2020 Jason Hoffman. All rights reserved.
//

import Foundation
import SwiftUI


struct Device: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

class Devices: ObservableObject {
    
    @EnvironmentObject var bt: Bluetooth
    @Published var deviceList = [Device]()
    
    init() {
        self.deviceList = loadDevices()
    }
    
    func loadDevices() -> [Device] {
        var dL = [Device]()
        for i in bt.peripherals {
            if let name = i.name {
                dL.append(Device(name: name))
            }
        }
        return dL
    }
    
    
    func connectToPeripheralWithName(_ name: String) {
        for i in bt.peripherals {
            if i.name == name {
                if bt.deviceNumber == 1 {
                    bt.p1Name = name
                } else if bt.deviceNumber == 2 {
                    bt.p2Name = name
                }
                bt.connectTo(i)
                bt.addPeripheral(i)
            }
        }
    }
}

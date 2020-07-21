//
//  DeviceList.swift
//  WahooCompare
//
//  Created by Jason Hoffman on 7/20/20.
//  Copyright © 2020 Jason Hoffman. All rights reserved.
//

import SwiftUI
import class CoreBluetooth.CBPeripheral

//struct Device: Identifiable {
//    let id = UUID()
//    let name: String
//}
//
//class Devices: ObservableObject {
//
//    static var bt = Bluetooth.sharedInstance
//    @Published var devices: [Device] = loadDevices()
//
//    static func loadDevices() -> [Device] {
//        for i in bt.peripherals {
//            if let name = i.name {
//                devices.append(Device(name: name))
//            }
//        }
//        return devices
//    }
//}
//
//
//struct DeviceList: View {
//    @ObservedObject private var devices = Devices()
//
//    var body: some View {
//        List(devices.devices) { d in
//
//        }
//    }
//}

struct DeviceListView: View {
    @ObservedObject private var devices = Devices()
    static var bt = Bluetooth.sharedInstance
    
    var body: some View {
        VStack(alignment: .trailing) {
            Button(action: {
                // action
            }) {
                Text("Close")
            }
            List(devices.deviceList) { d in
                DeviceRow(device: d)
            }
        }
    }
    
    struct Device: Identifiable {
        let id = UUID()
        let name: String
    }
    
    class Devices: ObservableObject {
        @Published var deviceList: [Device] = loadDevices()
        static var dL = [Device]()
        
        static func loadDevices() -> [Device] {
            for i in bt.peripherals {
                if let name = i.name {
                    dL.append(Device(name: name))
                }
            }
            return dL
        }
    }
    
    struct DeviceRow: View {
        let device: Device
        
        var body: some View {
            Text(device.name)
        }
    }
}

struct DeviceList_Previews: PreviewProvider {
    static var previews: some View {
        DeviceListView()
    }
}

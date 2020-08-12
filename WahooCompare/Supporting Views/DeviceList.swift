//
//  DeviceList.swift
//  WahooCompare
//
//  Created by Jason Hoffman on 7/20/20.
//  Copyright © 2020 Jason Hoffman. All rights reserved.
//

import SwiftUI
import Combine
import class CoreBluetooth.CBPeripheral


struct DeviceListView: View {
    
    @ObservedObject private var devices = Devices()
    @State private var selected: UUID?
    @Binding var isPresented: Bool
    @Binding var name: String
    static var bt = Bluetooth.sharedInstance
    // Can add bindings to custom initializer
    
    struct Device: Identifiable, Hashable {
        let id = UUID()
        let name: String
    }

    class Devices: ObservableObject {
        
        @Published var deviceList: [Device] = loadDevices()

        static func loadDevices() -> [Device] {
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
                    bt.connectTo(i)
                    bt.addPeripheral(i)
                }
            }
        }
    }

    struct DeviceRow: View {
        let device: Device
        
        var body: some View {
            Text(device.name)
        }
    }
    
    var body: some View {
        NavigationView {
            List(devices.deviceList, selection: $selected) { d in
                DeviceRow(device: d).tag(d.name)
            }.environment(\.editMode, .constant(.active))
        .navigationBarTitle(Text("Choose a Device"))
                .navigationBarItems(trailing: Button(action: {
                    self.isPresented = false
                    
                    for i in self.devices.deviceList {
                        if self.selected!.uuidString == i.id.uuidString {
                            self.devices.connectToPeripheralWithName(i.name)
                            self.name = i.name
                        }
                    }
                }, label: {
                    Text("Connect")
                        .fontWeight(.heavy)
                }))
        }
    }
    

    
}


//struct DeviceList_Previews: PreviewProvider {
//    static var previews: some View {
//        return DeviceListView(isPresented: Binding(true))
//    }
//}

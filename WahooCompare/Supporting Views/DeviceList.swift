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
    @State private var selected: UUID? = nil
    @Binding var isPresented: Bool
    
    static var bt = Bluetooth.sharedInstance
    
    var body: some View {
        NavigationView {
            List(devices.deviceList, selection: $selected) { d in
                DeviceRow(device: d).tag(d.name)
            }.environment(\.editMode, .constant(.active))
        .navigationBarTitle(Text("Choose a Device"))
                .navigationBarItems(trailing: Button(action: {
                    self.isPresented = false
                }, label: {
                    Text("Connect")
                        .fontWeight(.heavy)
                }))
        }
    }
    
    struct Device: Identifiable, Hashable {
        let id = UUID()
        let name: String
    }
    
    class Devices: ObservableObject {
        
        @Published var deviceList: [Device] = loadDevices()
//        @Published var selectedDevice: Set<Device>
        
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

//struct DeviceList_Previews: PreviewProvider {
//    static var previews: some View {
//        return DeviceListView(isPresented: Binding(true))
//    }
//}

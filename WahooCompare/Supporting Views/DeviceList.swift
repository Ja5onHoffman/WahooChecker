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
    
    @State var selected: UUID?
    @Binding var isPresented: Bool
    @Binding var name: String
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var bt: Bluetooth

    
    struct DeviceRow: View {
        let device: Bluetooth.Device
        
        var body: some View {
            Text(device.name)
        }
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
    
    var body: some View {
        NavigationView {
            List(self.bt.deviceList, selection: $selected) { d in
                DeviceRow(device: d).tag(d.name)
            }.environment(\.editMode, .constant(.active))
        .navigationBarTitle(Text("Choose a Device"))
                .navigationBarItems(trailing: Button(action: {
                    self.isPresented = false
                    for i in self.bt.deviceList {
                        if self.selected!.uuidString == i.id.uuidString {
                            self.connectToPeripheralWithName(i.name)
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

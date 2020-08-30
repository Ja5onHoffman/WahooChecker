//
//  DataBox.swift
//  WahooCompare
//
//  Created by Jason Hoffman on 7/9/20.
//  Copyright © 2020 Jason Hoffman. All rights reserved.
//

import SwiftUI

struct DataBox: View {
    
    @State var showingDevices = false
    @State var deviceName: String = ""
    var deviceNumber: Int = 0
    @State var name1 = "Device 1"
    @State var name2 = "Device 2"
    @EnvironmentObject var bt: Bluetooth
    // Required for SwiftUI bug
    @Environment(\.managedObjectContext) var moc
    
    
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.white)
                    .shadow(radius: 10)
                    .padding(EdgeInsets(top: 0, leading: 5.0, bottom: 5.0, trailing: 5.0))
                    .aspectRatio(1.5, contentMode: .fill)
                VStack(spacing: 70) {
                    Text(name1)
                        .padding(EdgeInsets(top: 10.0, leading: 20.0, bottom: 10.0, trailing: 20.0))
                        .background(Color.black)
                        .cornerRadius(20.0)
                        .font(.title)
                        .foregroundColor(.white)
                    Text(String(format:"%.0f", bt.p1Power.value))
                    Button(action: {
                        if let p = self.bt.p1 {
                            self.bt.disconnect(p)
                        } else {
                            self.showingDevices.toggle()
                        }
                    }, label: { Text(name1 == "Device 1" ? "Connect Device" : "Disconnect") })
                        .sheet(isPresented: $showingDevices) {
                            DeviceListView(isPresented: self.$showingDevices, name:
                                self.$deviceName).environment(\.managedObjectContext, self.moc).environmentObject(self.bt).onAppear {
                                self.bt.setDeviceNumber(1)
                                self.bt.scan()
                            }.onDisappear {
                                self.bt.stopScan()
                                
                            }
                    }
                        .padding()
                        .background(name1 == "Device 1" ? Color.green : Color.red)
                        .cornerRadius(20)
                
                }
            }
            ZStack {
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.white)
                    .shadow(radius: 10)
                    .padding(EdgeInsets(top: 0, leading: 5.0, bottom: 5.0, trailing: 5.0))
                    .aspectRatio(1.5, contentMode: .fill)
                VStack(spacing: 70) {
                    Text(name2)
                        .padding(EdgeInsets(top: 10.0, leading: 20.0, bottom: 10.0, trailing: 20.0))
                        .background(Color.black)
                        .cornerRadius(20.0)
                        .font(.title)
                        .foregroundColor(.white)
                    Text(String(format:"%.0f", bt.p2Power.value))
                    Button(action: {
                        if let p = self.bt.p2 {
                            self.bt.disconnect(p)
                        } else {
                            self.showingDevices.toggle()
                        }
                    }, label: { Text(name2 == "Device 2" ? "Connect Device" : "Disconnect") })
                        .sheet(isPresented: $showingDevices) {
                            DeviceListView(isPresented: self.$showingDevices, name: self.$deviceName).environment(\.managedObjectContext, self.moc).environmentObject(self.bt).onAppear {
                                self.bt.setDeviceNumber(2)
                                self.bt.scan()
                            }.onDisappear {
                                self.bt.stopScan()
                            }
                    }
                        .padding()
                        .background(name2 == "Device 2" ? Color.green : Color.red)
                        .cornerRadius(20)
                
                }
            }
        }

    }
}



struct DataBox_Previews: PreviewProvider {
    static var previews: some View {
        DataBox()
    }
}

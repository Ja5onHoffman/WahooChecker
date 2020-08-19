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
    var name: String = "Device" 
    var bt = Bluetooth.sharedInstance
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.white)
                    .shadow(radius: 10)
                    .padding(EdgeInsets(top: 0, leading: 5.0, bottom: 5.0, trailing: 5.0))
                    .aspectRatio(1.5, contentMode: .fill)
                VStack(spacing: 70) {
                    Text(name)
                        .padding(EdgeInsets(top: 10.0, leading: 20.0, bottom: 10.0, trailing: 20.0))
                        .background(Color.black)
                        .cornerRadius(20.0)
                        .font(.title)
                        .foregroundColor(.white)
                    Text("\(bt.p1Power.value)")
                    Button(action: {
                        self.showingDevices.toggle()
                    }, label: { Text("Connect Device") })
                        .sheet(isPresented: $showingDevices) {
                            DeviceListView(isPresented: self.$showingDevices, name: self.$deviceName).onAppear {
                                self.bt.setDeviceNumber(1)
                                self.bt.scan()
                            }.onDisappear {
                                self.bt.stopScan()
                            }
                    }
                        .padding()
                        .background(Color.green)
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
                    Text(name)
                        .padding(EdgeInsets(top: 10.0, leading: 20.0, bottom: 10.0, trailing: 20.0))
                        .background(Color.black)
                        .cornerRadius(20.0)
                        .font(.title)
                        .foregroundColor(.white)
                    Text("\(bt.p2Power.value)")
                    Button(action: {
                        self.showingDevices.toggle()
                    }, label: { Text("Connect Device") })
                        .sheet(isPresented: $showingDevices) {
                            DeviceListView(isPresented: self.$showingDevices, name: self.$deviceName).onAppear {
                                self.bt.setDeviceNumber(2)
                                self.bt.scan()
                            }.onDisappear {
                                self.bt.stopScan()
                            }
                    }
                        .padding()
                        .background(Color.green)
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

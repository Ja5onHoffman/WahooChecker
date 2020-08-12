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
    var name: String = "Device" 
    var bt = Bluetooth.sharedInstance
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.white)
                .shadow(radius: 10)
                .padding(EdgeInsets(top: 0, leading: 5.0, bottom: 5.0, trailing: 5.0))
                .aspectRatio(1.3, contentMode: .fit)
            VStack(spacing: 70) {
                Text(name)
                    .padding(EdgeInsets(top: 10.0, leading: 20.0, bottom: 10.0, trailing: 20.0))
                    .background(Color.black)
                    .cornerRadius(20.0)
                    .font(.title)
                    .foregroundColor(.white)
                Text("\(bt.power.value)")
                Button(action: {
                    self.showingDevices.toggle()
                }, label: { Text("Connect Device") })
                    .sheet(isPresented: $showingDevices) {
                        DeviceListView(isPresented: self.$showingDevices, name: self.$deviceName).onAppear {
                            self.bt.scan()
                        }
                }
                    .padding()
                    .background(Color.green)
                    .cornerRadius(20)
            
            }
        }
    }
}



//struct DataBox_Previews: PreviewProvider {
//    static var previews: some View {
//        DataBox("Device")
//    }
//}

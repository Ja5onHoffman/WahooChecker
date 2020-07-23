//
//  DataBox.swift
//  WahooCompare
//
//  Created by Jason Hoffman on 7/9/20.
//  Copyright © 2020 Jason Hoffman. All rights reserved.
//

import SwiftUI

struct BorderRect: View {

    @ObservedObject var bt = Bluetooth.sharedInstance
    @State var showingDevices = false
    
    var name: String!
    
    init(_ name: String) {
        self.name = name
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.white)
                .shadow(radius: 10)
                .padding(EdgeInsets(top: 0, leading: 5.0, bottom: 5.0, trailing: 5.0))
                .aspectRatio(1.0, contentMode: .fit)
            VStack(spacing: 110) {
                Text(name)
                    .padding(EdgeInsets(top: 10.0, leading: 20.0, bottom: 10.0, trailing: 20.0))
                    .background(Color.black)
                    .cornerRadius(20.0)
                    .font(.title)
                    .foregroundColor(.white)
                Text("Watts")
                Button(action: {
                    self.showingDevices.toggle()
                }, label: { Text("Connect Device") })
                    .sheet(isPresented: $showingDevices) {
                        DeviceListView(isPresented: self.$showingDevices).onAppear {
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

struct DataBox: View {
    
    var body: some View {
        BorderRect("Device")
    }
}

struct DataBox_Previews: PreviewProvider {
    static var previews: some View {
        DataBox()
    }
}

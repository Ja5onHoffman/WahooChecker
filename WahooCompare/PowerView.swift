//
//  ContentView.swift
//  WahooCompare
//
//  Created by Jason Hoffman on 7/8/20.
//  Copyright © 2020 Jason Hoffman. All rights reserved.
//

import SwiftUI
import CoreBluetooth

let powerMeterCBUUID = CBUUID(string: "0x1818")
let powerMeasurementCharacteristicCBUUID = CBUUID(string: "0x2A63")


struct PowerView: View {

    var btOne = BluetoothOne.sharedInstance
    var btTwo = BluetoothTwo.sharedInstance

    var body: some View {
        
        VStack {
            DataBox(btOne.deviceName, btOne)
            DataBox(btTwo.deviceName, btTwo)
            GraphView() 
        }.onAppear {
            print(self.btOne.centralManager.state.rawValue)
            print(self.btTwo.centralManager.state.rawValue)
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PowerView()
    }
}

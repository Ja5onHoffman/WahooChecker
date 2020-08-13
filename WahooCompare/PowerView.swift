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

    let bt = Bluetooth.sharedInstance

    var body: some View {
        
        VStack {
            DataBox()
            GraphView()
        }.onAppear {
            print(self.bt.centralManager.state.rawValue)
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PowerView()
    }
}

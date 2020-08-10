//
//  PowerArray.swift
//  WahooCompare
//
//  Created by Jason Hoffman on 8/9/20.
//  Copyright © 2020 Jason Hoffman. All rights reserved.
//

import Foundation

struct PowerData: Identifiable {
    let id = UUID()
    let value: Double
    let device: Int = 0
}

class PowerArray {
    
    let size: Int?
    var values = [PowerData]()
    
    init(size: Int) {
        self.size = size
    }
    
    func addValue(_ val: PowerData) {
        guard let s = size else { return }
        if values.count < s {
            values.append(val)
        } else {
            values.removeFirst()
            values.append(val)
        }

    }
    
    func zero() -> PowerData {
        return PowerData(value: 0)
    }
}

//
//  PowerArray.swift
//  WahooCompare
//
//  Created by Jason Hoffman on 8/9/20.
//  Copyright © 2020 Jason Hoffman. All rights reserved.
//

import Foundation
import SwiftUI

struct PowerData: Identifiable, Hashable {
    let id = UUID()
    var value: CGFloat
    let device: Int = 0
}

struct PowerArray: Identifiable {
    var id = UUID() 
    
    let size: Int?
    var values = [PowerData](repeating: PowerData(value: 0), count: 100)
    
    init(size: Int) {
        self.size = size
    }
    
    mutating func addValue(_ val: PowerData) {
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

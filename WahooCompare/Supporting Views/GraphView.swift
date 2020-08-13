//
//  GraphView.swift
//  WahooCompare
//
//  Created by Jason Hoffman on 7/30/20.
//  Copyright © 2020 Jason Hoffman. All rights reserved.
//

import SwiftUI



struct GraphView: View {
    var sampleData: [Int] = [0, 200, 100, 300, 50, 600, 800, 100]

    let bt = Bluetooth.sharedInstance
    
    func degreeHeight(_ height: CGFloat, range: Int) -> CGFloat {
      height / CGFloat(range)
    }
    
    func dayWidth(_ width: CGFloat, count: Int) -> CGFloat {
      width / CGFloat(count)
    }
    
    func dayOffset(_ date: Date, dWidth: CGFloat) -> CGFloat {
      CGFloat(Calendar.current.ordinality(of: .day, in: .year, for: date)!) * dWidth
    }
    
    func tempOffset(_ temperature: Double, degreeHeight: CGFloat) -> CGFloat {
      CGFloat(temperature + 10) * degreeHeight
    }
    
    func tempLabelOffset(_ line: Int, height: CGFloat) -> CGFloat {
      height - self.tempOffset(Double(line * 10), degreeHeight: self.degreeHeight(height, range: 100))
    }
    
    var body: some View {
        
        // This could be made to scale with higher watts
        GeometryReader { r in
            ForEach(0..<9) { line in
                Group {
                    Path { path in
                        let yh = self.tempLabelOffset(line, height: r.size.height)
                        path.move(to: CGPoint(x: 0, y: yh))
                        path.addLine(to: CGPoint(x: r.size.width, y: yh))
                    }.stroke(line == 0 ? Color.black : Color.gray)
                    if line >= 0 {
                      Text("\(line * 100)W")
                        .offset(x: 10, y: self.tempLabelOffset(line, height: r.size.height))
                        .font(.system(size: 8))
                    }
                }
            }
            
            // Last n indicies of array
            // Or limit length to 500
            ForEach(self.bt.p1Values.values) { d in
                Path { path in
                   let h = r.size.height
                    let width = self.dayWidth(r.size.width, count: 500)
//                    let offset = self.dayOffset(d, dWidth: width)
                   let wHeight = self.degreeHeight(h, range: 800)
                   let low = self.tempOffset(0.0, degreeHeight: wHeight)
                   let high = self.tempOffset(800.0, degreeHeight: 100)
                   path.move(to: CGPoint(x: 0, y: self.tempLabelOffset(0, height: r.size.height)))
                   path.addLine(to: CGPoint(x: 100, y: self.tempLabelOffset(8, height: r.size.height)))

                }.stroke(Color.blue, lineWidth: 10)
            }
            
            ForEach(self.bt.p2Values.values) { d in
                Path { path in
                   let h = r.size.height
                    let width = self.dayWidth(r.size.width, count: 500)
//                    let offset = self.dayOffset(d, dWidth: width)
                   let wHeight = self.degreeHeight(h, range: 800)
                   let low = self.tempOffset(0.0, degreeHeight: wHeight)
                   let high = self.tempOffset(800.0, degreeHeight: 100)
                   path.move(to: CGPoint(x: 0, y: self.tempLabelOffset(0, height: r.size.height)))
                   path.addLine(to: CGPoint(x: 100, y: self.tempLabelOffset(8, height: r.size.height)))

                }.stroke(Color.blue, lineWidth: 10)
            }
            
            
        }
    }
}


struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}

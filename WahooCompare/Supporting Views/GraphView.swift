//
//  GraphView.swift
//  WahooCompare
//
//  Created by Jason Hoffman on 7/30/20.
//  Copyright © 2020 Jason Hoffman. All rights reserved.
//

import SwiftUI


struct LineGraph: Shape {
    var dataPoints: [CGFloat]
    var max: CGFloat = 800.0
    func path(in rect: CGRect) -> Path {
        func point(at ix: Int) -> CGPoint {
            let point = dataPoints[ix] / max
            let x = rect.width * CGFloat(ix) / CGFloat(dataPoints.count - 1)
            let y = (1-point) * rect.height
            return CGPoint(x: x, y: y)
        }

        return Path { p in
            guard dataPoints.count > 1 else { return }
            let start = dataPoints[0]
            p.move(to: CGPoint(x: 0, y: 0))
            for idx in dataPoints.indices {
                p.addLine(to: point(at: idx))
            }
        }
    }
}

var sampleData: [CGFloat] = [0, 200.00, 100.00, 300, 50.0, 60.0, 80.0, 100.0]

struct GraphView: View {
    
    var bt = Bluetooth.sharedInstance
    
    func degreeHeight(_ height: CGFloat, range: Int) -> CGFloat {
      height / CGFloat(range)
    }
    
    func tempOffset(_ temperature: Double, degreeHeight: CGFloat) -> CGFloat {
      CGFloat(temperature + 10) * degreeHeight
    }
    
    func tempLabelOffset(_ line: Int, height: CGFloat) -> CGFloat {
      height - self.tempOffset(Double(line * 10), degreeHeight: self.degreeHeight(height, range: 100))
    }
    
//    Path { p in
//      // 3
//      let dWidth = self.dayWidth(reader.size.width, count: 365)
//      let dHeight = self.degreeHeight(reader.size.height, range: 110)
//      // 4
//      let dOffset = self.dayOffset(measurement.date, dWidth: dWidth)
//      let lowOffset = self.tempOffset(measurement.low, degreeHeight: dHeight)
//      let highOffset = self.tempOffset(measurement.high, degreeHeight: dHeight)
//      // 5
//      p.move(to: CGPoint(x: dOffset, y: reader.size.height - lowOffset))
//      p.addLine(to: CGPoint(x: dOffset, y: reader.size.height - highOffset))
//      // 6
//    }.stroke()
    
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
            
            Path { path in
                           let h = r.size.height
                           let wHeight = self.degreeHeight(h, range: 800)
                           let low = self.tempOffset(0.0, degreeHeight: wHeight)
                           let high = self.tempOffset(800.0, degreeHeight: 100)
                           path.move(to: CGPoint(x: 0, y: self.tempLabelOffset(0, height: r.size.height)))
                // Works to scale
                           path.addLine(to: CGPoint(x: 100, y: self.tempLabelOffset(8, height: r.size.height)))

                       }
                       .stroke(Color.blue, lineWidth: 10)

        }
    }
}


struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}

//
//  GraphView.swift
//  WahooCompare
//
//  Created by Jason Hoffman on 7/30/20.
//  Copyright © 2020 Jason Hoffman. All rights reserved.
//

import SwiftUI


struct GraphView: View {
    let sampleData: [CGFloat] = [500.0, 200.0, 200.0, 600.0, 800.0, 100.0, 200.0, 300.0, 200.0]

    let bt = Bluetooth.sharedInstance
    
    func scaleHeight(_ height: CGFloat, range: Int) -> CGFloat {
      height / CGFloat(range)
    }

    func pointOffset(_ value: CGFloat, scaleHeight: CGFloat) -> CGFloat {
      CGFloat(value) * scaleHeight
    }
    
    func powerLabelOffset(_ line: Int, height: CGFloat) -> CGFloat {
      height - self.pointOffset(CGFloat(line * 100), scaleHeight: self.scaleHeight(height, range: 800))
    }
    
    func xIncrement(_ width: CGFloat, _ count: Int) -> CGFloat {
      return width / CGFloat(count)
    }
    
    func xOffset(_ n: Int, _ xIncrement: CGFloat) -> CGFloat {
        return CGFloat(n) * xIncrement
    }
    
    var body: some View {
        
        // This could be made to scale with higher watts
        GeometryReader { r in
                Path { path in
                    let height = r.size.height
                    let width = r.size.width
                    let scale = self.scaleHeight(height, range: 800)
                    let firstPointY = self.pointOffset(0.0, scaleHeight: scale)
                    path.move(to: .init(x: 0, y: firstPointY))
                    for i in 0..<self.sampleData.count {
                        path.addLine(to:
                            CGPoint(
                                x: self.xOffset(i, self.xIncrement(width, self.sampleData.count)),
                                y: height - self.pointOffset(self.sampleData[i], scaleHeight: scale))
                        )
                        print(height - self.pointOffset(self.sampleData[i], scaleHeight: scale))
                    }
                }.stroke(style: .init(lineWidth: 5.0, lineCap: .round, lineJoin: .round))
    
            
                ForEach(0..<9) { line in
                    Group {
                        Path { path in
                            let scale = self.scaleHeight(r.size.height, range: 800)
                            let yh = self.powerLabelOffset(line, height: r.size.height)
//                            let yh = self.scaleHeight(r.size.height, range: 100)
                            path.move(to: CGPoint(x: 0, y: yh))
                            path.addLine(to: CGPoint(x: r.size.width, y: yh))
                        }.stroke(line == 0 ? Color.black : Color.gray)
                        if line >= 0 {
                          Text("\(line * 100)W")
                            .offset(x: 10, y: self.powerLabelOffset(line, height: r.size.height))
                            .font(.system(size: 8))
                    }
                }
            }
        }
    }
}



struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}

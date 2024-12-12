//
//  ParentTabCentShape.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/12/07.
//

import SwiftUI

struct SlideableTabShape: Shape {
    let selectParentTabIndex: Int
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let startPoint = CGPoint(x: rect.maxX - 10, y: rect.minY)
        let bt = CGPoint(x: rect.maxX, y: rect.maxY)
        let bl = CGPoint(x: rect.minX - 10, y: rect.maxY)
        let tl = CGPoint(x: rect.minX, y: rect.minY)
        
        path.move(to: startPoint)
        path.addRelativeArc(center: CGPoint(x: rect.maxX - 10, y: rect.minY + 10),
                            radius: 10,
                            startAngle: Angle.degrees(270),
                            delta: Angle.degrees(90))
        path.addLine(to: bt)
        path.addRelativeArc(center: CGPoint(x: rect.maxX + 10, y: rect.maxY - 10),
                            radius: -10,
                            startAngle: Angle.degrees(0),
                            delta: Angle.degrees(-90))
        path.addLine(to: bl)
        path.addRelativeArc(center: CGPoint(x: rect.minX - 10, y: rect.maxY - 10),
                            radius: -10,
                            startAngle: Angle.degrees(270),
                            delta: Angle.degrees(-90))
        path.addLine(to: tl)
        path.addRelativeArc(center: CGPoint(x: rect.minX + 10, y: rect.minY + 10),
                            radius: 10,
                            startAngle: Angle.degrees(180),
                            delta: Angle.degrees(90))
        return path
    }
}

#Preview {
    ContentView()
}

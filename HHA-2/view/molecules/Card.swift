//
//  Card.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/13.
//

import SwiftUI

struct Card<Content: View>: View {
    var radiuses: [CGFloat] = [10, 10, 10, 10]
    var cardColor: Color = .changeable
    var shadowColor: Color = .changeableShadow
    var shadowRadius: CGFloat = 5
    @ViewBuilder var content: Content
    var body: some View {
        UnevenRoundedRectangle(topLeadingRadius: radiuses[0], bottomLeadingRadius: radiuses[1], bottomTrailingRadius: radiuses[2], topTrailingRadius: radiuses[3])
            .fill(cardColor)
            .shadow(color: shadowColor, radius: shadowRadius)
            .compositingGroup()
            .overlay {
                content
            }
    }
}

//
//  Card.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/13.
//

import SwiftUI

struct Card: View {
    var radiuses: [CGFloat] = [10, 10, 10, 10]
    var body: some View {
        UnevenRoundedRectangle(topLeadingRadius: radiuses[0], bottomLeadingRadius: radiuses[1], bottomTrailingRadius: radiuses[2], topTrailingRadius: radiuses[3])
            .fill(.changeable)
            .shadow(color: .changeableShadow, radius: 5)
    }
}

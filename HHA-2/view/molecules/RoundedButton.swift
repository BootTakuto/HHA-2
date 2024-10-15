//
//  RoundedButton.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/13.
//

import SwiftUI

struct RoundedButton: View {
    var radius: CGFloat = .infinity
    var color: Color = .changeable
    var text: String = ""
    var imageNm: String = ""
    var font: Font = .caption
    var textColor: Color = .changeableText
    var shadwoRadius: CGFloat = 3
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: radius)
                    .fill(color)
                HStack {
                    if text != "" {
                        Text(text)
                    }
                    if imageNm != "" {
                        Image(systemName: imageNm)
                    }
                }.font(font)
                    .foregroundStyle(textColor)
            }.compositingGroup()
                .shadow(color: .changeableShadow.opacity(0.5), radius: shadwoRadius)
        }
    }
}

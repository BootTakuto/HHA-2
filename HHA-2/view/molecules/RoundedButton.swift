//
//  RoundedButton.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/13.
//

import SwiftUI

struct RoundedButton: View {
    var radius: CGFloat
    var color: Color
    var text: String = ""
    var imageNm: String = ""
    var font: Font = .caption
    var shadwoRadius: CGFloat = 3
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            GeometryReader { geometry in
                ZStack {
                    RoundedRectangle(cornerRadius: radius)
                        .fill(color)
                        .shadow(color: .changeableShadow, radius: shadwoRadius)
                    HStack {
                        if text != "" {
                            Text(text)
                        }
                        if imageNm != "" {
                            Image(systemName: imageNm)
                        }
                    }.font(font)
                        .foregroundStyle(.changeableText)
                }
            }
        }
    }
}

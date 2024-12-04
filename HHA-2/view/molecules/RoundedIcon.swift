//
//  RoudedIcon.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/27.
//

import SwiftUI

struct RoundedIcon: View {
    var radius: CGFloat = 10
    var image: String = "yensign"
    var text: String = ""
    var rectColor: Color = .mint
    var iconColor: Color = .changeableText
    var rectSize: CGFloat = 30
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: radius)
                .fill(rectColor)
            if text != "" {
                VStack(spacing: 0) {
                    Image(systemName: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: rectSize / 2, height: rectSize / 2)
                    Text(text)
                        .font(.system(size: 8, weight: .medium))
                        .lineLimit(1)
                        .padding(1)
                }.foregroundStyle(iconColor)
            } else {
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .padding(10)
                    .foregroundStyle(iconColor)
            }
        }.frame(width: rectSize, height: rectSize)
    }
}

#Preview {
    RoundedIcon(text: "あいうえおかきくけこ", rectSize: 45)
}

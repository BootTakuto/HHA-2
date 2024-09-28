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
    var rectColor: Color = .mint
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: radius)
                .fill(rectColor)
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .padding(10)
                .foregroundStyle(.changeableText)
        }.frame(width: 30, height: 30)
    }
}

#Preview {
    RoundedIcon()
}

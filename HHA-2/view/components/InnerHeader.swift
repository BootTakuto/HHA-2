//
//  InnerHeader.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/14.
//

import SwiftUI

struct InnerHeader<Content: View>: View {
    @Binding var isShow: Bool
    var hiddenOffset: CGFloat
    var height: CGFloat
    @ViewBuilder var content: Content
    var body: some View {
        ZStack {
            UnevenRoundedRectangle(bottomLeadingRadius: 20)
                .fill(.changeable)
                .shadow(color: .changeableShadow, radius: 5)
            VStack {
                VStack(spacing: 0) {
                    content
                        .frame(height: height - 20)
                    Image(systemName: "chevron.compact.down")
                        .rotationEffect(Angle(degrees: isShow ? 180 : 0))
                        .frame(width: .infinity, height: 20)
                }
            }
        }.frame(height: height)
            .onTapGesture {
                withAnimation {
                    self.isShow.toggle()
                }
            }.offset(y: isShow ? 0 : hiddenOffset)
    }
}

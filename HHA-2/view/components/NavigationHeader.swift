//
//  Header.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/10/29.
//

import SwiftUI

struct NavigationHeader: View {
    var title: String
    @Binding var isPresented: Bool
    var proxy: GeometryProxy
    var isLastPage = true
    var accentColor = CommonViewModel.getAccentColor()
    var accentTextColor = CommonViewModel.getTextColor()
    var isShowInnerHeader = true
    var body: some View {
        let size = proxy.size
        let safeAreaInsets = proxy.safeAreaInsets
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: isShowInnerHeader ? 0 : 20)
                .fill(.changeable)
            UnevenRoundedRectangle(bottomTrailingRadius: isLastPage ? 20 : 0)
                .fill(accentColor)
                .shadow(color: isShowInnerHeader ? .clear : .changeableShadow, radius: 5)
            VStack {
                Spacer()
                    .frame(height: safeAreaInsets.top - 5)
                HStack(spacing: 0) {
                    Button(action: {
                        self.isPresented = false
                    }) {
                        Image(systemName: "chevron.left")
                            .fontWeight(.medium)
                            .foregroundStyle(accentTextColor)
                    }
                    HStack {
                        Text(title)
                            .font(.title3)
                            .fontWeight(.medium)
                        Button(action: {
                            
                        }) {
                            Image(systemName: "questionmark.circle")
                        }
                    }.frame(maxWidth: size.width, alignment: .center)
                    Spacer()
                        .frame(width: 15)
                }.padding(.horizontal, 20)
                    .foregroundStyle(accentTextColor)
            }
        }.frame(height:  safeAreaInsets.top + 50)
    }

}

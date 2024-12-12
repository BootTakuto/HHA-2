//
//  CustomTab.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/12.
//

import SwiftUI

struct CustomTab: View {
    var accentColor: Color
    var accentTextColor: Color
    @Binding var pageIndex: Int
    let pageIcons: [String]
    let pageNames: [String]
    var body: some View {
        ZStack {
            UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20)
                .fill(.changeable)
                .shadow(color: .changeableShadow, radius: 5)
            Tabs()
        }.frame(height: 60)
    }
    
    @ViewBuilder
    func Tabs() -> some View {
        HStack(spacing: 0) {
            ForEach(pageIcons.indices, id: \.self) { index in
                let isSelected = self.pageIndex == index
                Rectangle()
                    .fill(.clear)
                    .overlay {
                        Button(action: {
                            withAnimation {
                                self.pageIndex = index
                            }
                        }) {
                            VStack(spacing: 5) {
                                Image(systemName: pageIcons[index])
                                    .frame(width: 25, height: 25)
                                    .background {
                                        Circle()
                                            .fill(isSelected ? accentColor : .clear)
                                    }.foregroundStyle(isSelected ? accentTextColor : .changeableText)
                                Text(isSelected ? pageNames[index] : "")
                                    .font(.system(size: 10))
                                    .foregroundStyle(.changeableText)
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}

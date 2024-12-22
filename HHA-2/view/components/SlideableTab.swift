//
//  SlideableTab.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/12/10.
//

import SwiftUI

struct SlideableTab: View {
    @Binding var selectIndex: Int
    var accentColor = CommonViewModel.getAccentColor()
    var accentTextColor = CommonViewModel.getTextColor()
    let titles: [SlideableTabTitle]
    @State var shapeOffset: CGFloat = 0
    var body: some View {
        GeometryReader { geom in
            let size = geom.size
            VStack(spacing: 0) {
                ZStack {
                    GeometryReader { proxy in
                        SlideableTabShape(selectParentTabIndex: selectIndex)
                            .fill(.changeable)
                            .shadow(color: .changeableShadow, radius: 5)
                            .offset(x: shapeOffset)
                            .frame(width: size.width / 3)
                    }.frame(height: 30)
                    HStack(spacing: 0) {
                        ForEach(titles.indices, id: \.self) { index in
                            let titleInfo = titles[index]
                            HStack {
                                if titleInfo.isSystemName {
                                    Image(systemName: titleInfo.icon)
                                        .fontWeight(.thin)
                                } else {
                                    ResizColableImage(titleInfo.icon, color: Color.changeableText)
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .fontWeight(.bold)
                                }
                                Text(titleInfo.title)
                            }.foregroundStyle(selectIndex == index ? .changeableText : accentTextColor)
                                .frame(width: size.width / 3)
                                .font(.footnote)
                                .onTapGesture {
                                    withAnimation {
                                        self.selectIndex = index
                                        self.shapeOffset = (size.width / 3) * CGFloat(index)
                                    }
                                }
                        }
                    }
                }
                let titleInfo = titles[selectIndex]
                UnevenRoundedRectangle(topLeadingRadius: titleInfo.rectTLRadi, topTrailingRadius: titleInfo.rectTTRadi)
                    .fill(.changeable)
            }.background {
                VStack {
                    Spacer()
                    Color.changeableShadow.blur(radius: 5)
                        .frame(height: size.height - 30)
                }
            }
        }
    }
}

struct SlideableTabTitle {
    var icon: String
    var title: String
    var rectTLRadi: CGFloat
    var rectTTRadi: CGFloat
    var isSystemName: Bool
    init(icon: String, title: String, rectTLRadi: CGFloat, rectTTRadi: CGFloat, isSystemName: Bool) {
        self.icon = icon
        self.title = title
        self.rectTLRadi = rectTLRadi
        self.rectTTRadi = rectTTRadi
        self.isSystemName = isSystemName
    }
}

#Preview {
    @Previewable @State var selectedIndex = 0
    var titles = [SlideableTabTitle(icon: "banknote", title: "資産・負債", rectTLRadi: 0, rectTTRadi: 0, isSystemName: true),
                  SlideableTabTitle(icon: "piggy.bank.no.coins", title: "家計", rectTLRadi: 10, rectTTRadi: 0, isSystemName: false),
                  SlideableTabTitle(icon: "gearshape", title: "その他", rectTLRadi: 10, rectTTRadi: 0, isSystemName: true)]
    SlideableTab(selectIndex: $selectedIndex, titles: titles)
}

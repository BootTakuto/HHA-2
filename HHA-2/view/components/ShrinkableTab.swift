//
//  ShrinkableTab.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/12/08.
//

import SwiftUI

struct ShrinkableTab: View {
    @Binding var selectedIndex: Int
    @State var accentColor = CommonViewModel.getAccentColor()
    @State var accentTextColor = CommonViewModel.getTextColor()
    @State var initTitle = TabData(title: "", iconNm: "")
    var titles: [TabData]
    var body: some View {
        GeometryReader { geom in
            HStack(spacing: -8) {
                ForEach(titles.indices, id: \.self) {index in
                    let titleModel = titles[index]
                    let isSelected = selectedIndex == index
                    HStack {
                        Image(systemName: titleModel.iconNm)
                            .foregroundStyle(isSelected ? accentTextColor : .gray)
                        if isSelected {
                            Text(titleModel.title)
                                .font(.caption)
                                .foregroundStyle(accentTextColor)
                        }
                    }.frame(width: isSelected ? 150 : 60, height: 40)
                        .background {
                            Rectangle()
                                .fill(isSelected ? accentColor : Color(uiColor: .systemGray6))
                        }.clipShape(.rect(cornerRadius: .infinity, style: .continuous))
                        .background {
                            RoundedRectangle(cornerRadius: .infinity)
                                .fill(.changeable)
                                .padding(-3)
                        }.onTapGesture {
                            withAnimation(.bouncy) {
                                if isSelected {
                                    selectedIndex = 0
                                } else {
                                    selectedIndex = index
                                }
                            }
                        }.padding(selectedIndex == index && index != 0 ? .horizontal : .trailing,
                                  selectedIndex == index ? 11 : 0)
                }
            }
        }.frame(height: 40)
            .onAppear {
                self.initTitle = titles[0]
            }
    }
}

struct TabData {
    var title: String
    var iconNm: String
    init(title: String, iconNm: String) {
        self.title = title
        self.iconNm = iconNm
    }
}



#Preview {
    @Previewable @State var selectIndex = 0
    var titles = [TabData(title: "資産・負債一覧", iconNm: "square.stack.3d.up"),
                  TabData(title: "資産一覧", iconNm: "hand.thumbsup"),
                  TabData(title: "負債一覧", iconNm: "hand.thumbsdown")]
    ShrinkableTab(selectedIndex: $selectIndex, titles: titles)
}

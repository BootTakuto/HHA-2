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
    @State var initTitle = ShrinableTabTitle(title: "", iconNm: "")
    var titles: [ShrinableTabTitle]
    var body: some View {
        GeometryReader { geom in
            HStack(spacing: selectedIndex == 0 ? -10 : 10) {
                ForEach(titles.indices, id: \.self) {index in
                    let titleModel = titles[index]
                    let isSelected = selectedIndex == index
                    if index != 0 {
                        HStack {
                            Image(systemName: titleModel.iconNm)
                                .foregroundStyle(isSelected ? accentTextColor : .gray)
                            if isSelected {
                                Text(titleModel.title)
                                    .font(.caption)
                                    .foregroundStyle(accentTextColor)
                            }
                        }.frame(width: isSelected ? 150 : 50, height: 40)
                            .background {
                                Rectangle()
                                    .fill(isSelected ? accentColor : Color(uiColor: .systemGray6))
                            }.clipShape(.rect(cornerRadius: 15, style: .continuous))
                            .background {
                                RoundedRectangle(cornerRadius: 17)
                                    .fill(.changeable)
                                    .padding(selectedIndex != 0 ? 0 : -3)
                            }
                            .onTapGesture {
                                withAnimation(.bouncy) {
                                    if isSelected {
                                        selectedIndex = 0
                                    } else {
                                        selectedIndex = index
                                    }
                                }
                            }
                    }
                }
                Spacer()
                HStack(spacing: 5) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(selectedIndex == 0 ? accentColor : Color(uiColor: .systemGray6))
                        HStack {
                            Image(systemName: initTitle.iconNm)
                                .foregroundStyle(selectedIndex == 0 ? accentTextColor : .gray)
                            Text(initTitle.title)
                                .font(.caption)
                                .foregroundStyle(accentTextColor)
                        }
                    }.frame(width: 150, height: 40)
                    Button(action: {
                        
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(accentColor)
                            Image(systemName: "questionmark")
                                .foregroundStyle(accentTextColor)
                        }.frame(width: 40, height: 40)
                    }
                }.offset(x: selectedIndex == 0 ? 0 : 205)
            }
        }.frame(height: 40)
            .padding(.horizontal, 10)
            .onAppear {
                self.initTitle = titles[0]
            }
    }
}

struct ShrinableTabTitle {
    var title: String
    var iconNm: String
    init(title: String, iconNm: String) {
        self.title = title
        self.iconNm = iconNm
    }
}



#Preview {
    @Previewable @State var selectIndex = 0
    var titles = [ShrinableTabTitle(title: "資産・負債一覧", iconNm: "square.stack.3d.up"),
                  ShrinableTabTitle(title: "資産一覧", iconNm: "hand.thumbsup"),
                  ShrinableTabTitle(title: "負債一覧", iconNm: "hand.thumbsdown")]
    ShrinkableTab(selectedIndex: $selectIndex, titles: titles)
}

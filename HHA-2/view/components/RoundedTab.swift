//
//  RoundedTab.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/12/14.
//

import SwiftUI

struct RoundedTab: View {
    @Binding var selectIndex: Int
    var tabDatas: [TabData]
    let accentColor: Color
    let accentTextColor: Color
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: .infinity)
                .fill(.changeable)
            HStack(spacing: 0) {
                ForEach(tabDatas.indices, id: \.self) { index in
                    let data = tabDatas[index]
                    let isSelected = selectIndex == index
                    VStack(spacing: 0) {
                        Circle()
                            .fill(isSelected ? accentColor : .clear)
                            .frame(width: 25)
                            .overlay {
                                Image(systemName: data.iconNm)
                                    .foregroundStyle(isSelected ? accentTextColor : .gray)
                            }
                        if isSelected {
                            Text(data.title)
                                .font(.caption)
                        }
                    }.frame(width: 80)
                        .onTapGesture {
                            withAnimation {
                                self.selectIndex = index
                            }
                        }
                }
            }
        }.frame(width: 80 * CGFloat(tabDatas.count), height: 50)
            .compositingGroup()
            .shadow(color: .changeableShadow, radius: 5)
    }
}

#Preview {
    @Previewable @State var selectedIndex = 0
    let tabDatas = [TabData(title: "一覧", iconNm: "list.bullet"),
                    TabData(title: "追加", iconNm: "plus"),
                    TabData(title: "追加", iconNm: "plus")]
    RoundedTab(selectIndex: $selectedIndex,
               tabDatas: tabDatas,
               accentColor: .yellow,
               accentTextColor: .black)
}

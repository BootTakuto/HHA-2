//
//  HouseHoldParentView.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/12/07.
//

import SwiftUI

struct PageScrollView: View {
    let colors:[Color] = [.red, .orange, .blue]
    let pageData = [TabData(title: "一覧", iconNm: "list.bullet"),
                    TabData(title: "追加", iconNm: "plus"),
                    TabData(title: "追加", iconNm: "plus")]
    @State var pageIndex = 0
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                ScrollViewReader { scrollProxy in
                    LazyHStack(spacing: 0) {
                        ForEach (pageData.indices, id: \.self) { index in
                            colors[index]
                                .containerRelativeFrame(.horizontal)
                        }
                    }.overlay(alignment: .bottom) {
                        RoundedTab(selectIndex: $pageIndex,
                                   tabDatas: pageData,
                                   accentColor: .yellow,
                                   accentTextColor: .black,
                                   scrollViewProxy: scrollProxy)
                    }
                }
            }.scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden)
        }.ignoresSafeArea()
    }
}

#Preview {
    PageScrollView()
}

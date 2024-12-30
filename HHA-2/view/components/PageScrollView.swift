//
//  HouseHoldParentView.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/12/07.
//

import SwiftUI

struct PageScrollView<Content: View>: View {
    var accentColor: Color
    var accentTextColor: Color
    let pageData: [TabData]
    let buttonsData: [PageScrollViewButtonData]
    @ViewBuilder var scrollPage: Content
    var body: some View {
        ScrollView(.horizontal) {
            ScrollViewReader { scrollProxy in
                HStack(spacing: 0) {
                    scrollPage
                        .containerRelativeFrame(.horizontal)
                }.frame(maxHeight: .infinity)
                .overlay(alignment: .bottom) {
                    RoundedTab(tabDatas: pageData,
                               buttonsData: buttonsData,
                               accentColor: accentColor,
                               accentTextColor: accentTextColor,
                               scrollViewProxy: scrollProxy)
                    .padding(.bottom, 20)
                }
            }
        }.scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .ignoresSafeArea(edges: .bottom)
    }
}

struct PageScrollViewButtonData {
    var label: String
    var imageNm: String
    var bgColor: Color
    var textColor: Color
    var action: () -> ()
    init(label: String, imageNm: String, bgColor: Color, textColor: Color, action: @escaping () -> Void) {
        self.label = label
        self.imageNm = imageNm
        self.bgColor = bgColor
        self.textColor = textColor
        self.action = action
    }
}

#Preview {
    PageScrollView(accentColor: .yellow, accentTextColor: .black,
        pageData: [TabData(title: "一覧", iconNm: "list.bullet"),
                              TabData(title: "追加", iconNm: "plus"),
                              TabData(title: "追加", iconNm: "plus")],
                   buttonsData: [PageScrollViewButtonData(label: "add",
                                                          imageNm: "plus",
                                                          bgColor: .yellow,
                                                          textColor: .black,
                                                          action: {print("aaaaa")})]) {
        Text("aaaa")
            .id(0)
        Text("bbbb")
            .id(1)
        Text("cccc")
            .id(2)
    }
}

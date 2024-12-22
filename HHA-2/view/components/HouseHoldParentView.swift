//
//  HouseHoldParentPage.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/12/21.
//

import SwiftUI

struct HouseHoldParentView: View {
    var accentColor: Color
    var accentTextColor: Color
    let tabData = [TabData(title: "収支", iconNm: "yensign.square"),
                   TabData(title: "カレンダー", iconNm: "calendar")]
    @State var buttonsData = [PageScrollViewButtonData]()
    @State var isInputShow = false
    var body: some View {
        NavigationStack {
            PageScrollView(pageData: tabData, buttonsData: buttonsData) {
                IncomeConsumePage()
                    .containerRelativeFrame(.horizontal)
                    .id(0)
                CalendarPage(accentColor: accentColor,
                             accentTextColor: accentTextColor)
                    .containerRelativeFrame(.horizontal)
                    .id(1)
            }
        }.onAppear {
            self.buttonsData = [PageScrollViewButtonData(label: "入力",
                                                         imageNm: "square.and.pencil",
                                                         bgColor: .yellow,
                                                         textColor: .black,
                                                         action: {self.isInputShow = true}),
                                PageScrollViewButtonData(label: "使い方",
                                                         imageNm: "questionmark",
                                                         bgColor: .yellow,
                                                         textColor: .black,
                                                         action: {})]
        }.fullScreenCover(isPresented: $isInputShow) {
            Text("close").onTapGesture {
                self.isInputShow = false
            }
        }
    }
}

#Preview {
    HouseHoldParentView(accentColor: .yellow, accentTextColor: .black)
}

//
//  BalanceLinkHistoryPage.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/12/15.
//

import SwiftUI

struct BalanceLinkHistoryPage: View {
    @State var selectedDate = Date()
    @State var selectedListInfoIndex = 0
    @State var linkHistoryList = []
    var body: some View {
        GeometryReader {
            let size = $0.size
            VStack(spacing: 0) {
                Title(title: "連携一覧", message: "この残高に連携された収支情報を一覧表示")
                HistoryList()
                    .padding(.vertical, 20)
                    .padding(.horizontal, 10)
            }.padding(.top, 20)
        }
    }
    
    @ViewBuilder
    func HistoryList() -> some View {
        VStack(spacing: 0) {
            ShrinkableTab(selectedIndex: $selectedListInfoIndex,
                          titles: [TabData(title: "収入・支出連携一覧", iconNm: "arrow.up.arrow.down"),
                                   TabData(title: "収入連携一覧", iconNm: "arrow.up"),
                                   TabData(title: "支出連携一覧", iconNm: "arrow.down")])
            YearMonthSelector(targetDate: $selectedDate)
            .padding(.top, 10)
            if linkHistoryList.isEmpty {
                VStack(spacing: 20) {
                    ResizColableImage("piggy.bank")
                        .frame(width: 65, height: 50)
                    Footnote(text: "連携された収入・支出は存在しません。")
                }.padding(.top, 100)
            } else {
                ScrollView {
                    ForEach(linkHistoryList.indices, id: \.self) { index in
                        
                    }
                }
            }
        }
    }
}

#Preview {
    BalanceLinkHistoryPage()
}

//
//  BalanceParentView.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/12/07.
//

import SwiftUI

struct BalanceParentView: View {
    var accentColor: Color
    var accentTextColor: Color
    var safeAreaInsets: EdgeInsets
    // 表示設定
    @State var isRegistBalSheetShow = false
    let tabDatas = [TabData(title: "一覧", iconNm: "list.bullet"), TabData(title: "追加", iconNm: "plus")]
    var body: some View {
        BalanceListPage(isRegistPagePresented: $isRegistBalSheetShow,
                        accentColor: accentColor,
                        accentTextColor: accentTextColor)
        .overlay(alignment: .bottom) {
            HStack(spacing: 10) {
                CircleButton(text: "追加", imageNm: "plus") {
                    self.isRegistBalSheetShow = true
                }.frame(width: 40)
                CircleButton(text: "使い方", imageNm: "questionmark") {
                    
                }.frame(width: 40)
            }.frame(height: 60)
                .padding(.bottom, 20)
        }.fullScreenCover(isPresented: $isRegistBalSheetShow) {
        RegistBalanacePage(isPresented: $isRegistBalSheetShow,
                           accentColor: accentColor,
                           accentTextColor: accentTextColor)
        }
    }
}

#Preview {
    ContentView()
}

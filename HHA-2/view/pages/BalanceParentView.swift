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
//    @State var selectPageIndex = 0
    let tabDatas = [TabData(title: "一覧", iconNm: "list.bullet"), TabData(title: "追加", iconNm: "plus")]
    var body: some View {
        ZStack(alignment: .bottom) {
//            switch selectPageIndex {
//            case 0:
                BalanceListPage(isRegistPagePresented: $isRegistBalSheetShow,
                                accentColor: accentColor,
                                accentTextColor: accentTextColor)
//            case 1:
//                RegistBalanacePage(accentColor: accentColor,
//                                   accentTextColor: accentTextColor)
//            default:
//                BalanceListPage(accentColor: accentColor,
//                                accentTextColor: accentTextColor)
//            }
            HStack(spacing: 15) {
//                RoundedTab(selectIndex: $selectPageIndex, tabDatas: tabDatas,
//                           accentColor: accentColor, accentTextColor: accentTextColor)
                CircleButton(text: "追加", imageNm: "plus") {
                    self.isRegistBalSheetShow = true
                }.frame(width: 40)
                CircleButton(text: "使い方", imageNm: "questionmark") {
                    
                }.frame(width: 40)
            }.padding(.bottom, 30)
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

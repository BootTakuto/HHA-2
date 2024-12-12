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
    @State var isRegistBalSheetShow = false
    var body: some View {
        GeometryReader {
            let localSize = $0.frame(in: .local).size
            ZStack(alignment: .bottom) {
                BalanceListPage()
                CircleButton(text: "追加", imageNm: "plus") {
                    self.isRegistBalSheetShow = true
                }.frame(width: 60)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 10)
                    .padding(.bottom, safeAreaInsets.bottom + 5)
            }
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

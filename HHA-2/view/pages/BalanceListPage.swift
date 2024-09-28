//
//  BalanceListPage.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/12.
//

import SwiftUI

struct BalanceListPage: View {
    var accentColor: Color
    @Binding var isTotalShow: Bool
    @State var isSheetShow = false
    // 画面表示設定
    @State var hiddenOffset: CGFloat = -50
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                BalTotaHeader(size: geometry.size)
                    .zIndex(1000)
                BalTotalList(size: geometry.size)
                    .offset(y: isTotalShow ? 0 : hiddenOffset)
                    .frame(height: geometry.size.height)
            }
        }
        .sheet(isPresented: $isSheetShow) {
            
        }
    }
    
    @ViewBuilder
    func BalTotaHeader(size: CGSize) -> some View {
        InnerHeader(isShow: $isTotalShow, hiddenOffset: hiddenOffset, height: 80) {
            HStack(spacing: 0) {
                Text("合計")
                    .frame(width: size.width / 2 - 10, alignment: .leading)
                    .padding(.leading, 10)
                Text("¥\(0)")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(width: size.width / 2 - 50, alignment: .trailing)
                RoundedButton(radius: .infinity, color: accentColor, imageNm: "plus") {
                    
                }.frame(width: 25, height: 25)
                    .padding(.leading, 5)
            }.font(.title3)
                .offset(y: 5)
        }
    }
    
    @ViewBuilder
    func BalDetaiCard(size: CGSize) -> some View {
        Card(radiuses: [0,0,10,10])
            .frame(height: 80)
            .overlay {
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(.orange)
                        .frame(width: 5)
                    
                    VStack {
                        HStack(spacing: 0) {
                            Text("テスト")
                                .frame(width: (size.width - 60) / 2, alignment: .leading)
                                .padding(.leading, 10)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            Spacer()
                        }
                        HStack(spacing: 0) {
                            Spacer()
                            Text("¥\(1000000)")
                                .frame(width: (size.width - 60) / 2, alignment: .trailing)
                                .padding(.trailing, 10)
                                .lineLimit(1)
                        }
                    }.font(.subheadline)
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
    }
    
    @ViewBuilder
    func BalTotalList(size: CGSize) -> some View {
//        VStack {
//            HStack {
//                Spacer()
//                RoundedButton(radius: .infinity, color: accentColor,
//                              text: "追加", imageNm: "") {
//                    self.isSheetShow = true
//                }.frame(width: 80, height: 25)
//            }.padding(.horizontal, 20)
//                .padding(.vertical, 10)
            ScrollView() {
                VStack {
                    ForEach(0 ..< 10, id: \.self) { index in
                        BalDetaiCard(size: size)
                            .padding(.bottom, 15)
                            .padding(.horizontal, 20)
                    }
                }.padding(.top, 10)
                    .padding(.bottom, isTotalShow ? 160 : 90)
            }.scrollIndicators(.hidden)
//        }
    }
}

#Preview {
   ContentView()
}

//#Preview {
//    BalanceListPage(accentColor: .orange)
//}

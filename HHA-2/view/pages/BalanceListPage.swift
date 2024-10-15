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
    @State var balanceList = BalanceViewModel().getBalnaceResults()
    // 残高入力関連
    @State var isSheetShow = false
    @State var inputBalNm = ""
    @State var selectBalColorIndex = 0
    // 画面表示設定
    @State var hiddenOffset: CGFloat = -50
    // ビューモデル
    let viewModel = BalanceViewModel()
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                BalTotaHeader(size: geometry.size)
                    .zIndex(1000)
                BalTotalList(size: geometry.size)
                    .offset(y: isTotalShow ? 0 : hiddenOffset)
                    .frame(height: geometry.size.height)
            }.floatingSheet(isPresented: $isSheetShow) {
                Card {
                    VStack(spacing: 0) {
                        Text("残高情報の登録")
                            .foregroundStyle(.changeableText)
                            .padding(.bottom, 5)
                            .padding(.top, 10)
                        Footnote(text: "残高")
                            .frame(width: geometry.size.width - 40, alignment: .leading)
                            .padding(.bottom, 10)
                        InputText(placeHolder: "20文字以内", text: $inputBalNm, isDispShadow: false)
                            .padding(.bottom, 10)
                        Footnote(text: "タグ")
                            .frame(width: geometry.size.width - 40, alignment: .leading)
                            .padding(.bottom, 10)
                        ScrollView {
                            VStack {
                                ForEach (0 ..< 5, id: \.self) { row in
                                    HStack(spacing: 30) {
                                        ForEach (0 ..< 6, id: \.self) { col in
                                            let index = col + (row * 6)
                                            Circle()
                                                .frame(width: 30)
                                                .overlay {
                                                    Text("\(index)")
                                                        .foregroundStyle(.black)
                                                }
                                        }
                                    }
                                }
                            }
                        }.frame(height: 130)
                            .scrollIndicators(.hidden)
                            .padding(.bottom, 20)
                        RoundedButton(radius: 10, color: accentColor, text: "登録") {
                            let balanceModel = BalanceModel()
                            balanceModel.balKey = UUID().uuidString
                            balanceModel.balName = inputBalNm
                            balanceModel.balColorIndex = selectBalColorIndex
                            viewModel.reigstBalance(balanceModel: balanceModel)
                            self.isSheetShow.toggle()
                        }.frame(height: 40)
                            .padding(.bottom, 10)
                        RoundedButton(radius: 10, color: .gray.opacity(0.5), text: "閉じる") {
                            self.isSheetShow.toggle()
                        }.frame(height: 40)
                    }.padding(.horizontal, 10)
                        .frame(height: 400, alignment: .top)
                }.frame(height: 400)
                    .presentationDetents([.fraction(0.999)])
                    .padding(.horizontal, 10)
//                    .presentationBackgroundInteraction(.enabled(upThrough: .height(300)))
            }
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
                    withAnimation {
                        self.isSheetShow.toggle()
                    }
                }.frame(width: 25, height: 25)
                    .padding(.leading, 5)
            }.font(.title3)
                .offset(y: 5)
        }
    }
    
    @ViewBuilder
    func BalDetaiCard(size: CGSize, balanceModel: BalanceModel) -> some View {
        let colors: [Color] = [.yellow, .orange]
        Card {
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: .infinity)
                    .fill(colors[balanceModel.balColorIndex])
                    .frame(width: 5, height: 60)
                VStack {
                    HStack(spacing: 0) {
                        Text(balanceModel.balName)
//                            .frame(width: (size.width - 100) / 2, alignment: .leading)
                            .padding(.leading, 10)
                            .lineLimit(1)
                        Spacer()
                    }
                    HStack(spacing: 0) {
                        Spacer()
                        Text("¥\(balanceModel.balAmount)")
//                            .frame(width: (size.width - 100) / 2, alignment: .trailing)
                            .padding(.trailing, 10)
                            .lineLimit(1)
                    }
                }.font(.subheadline)
                Image(systemName: "chevron.compact.right")
                    .foregroundStyle(.gray)
            }.padding(.horizontal, 10)
        }.frame(height: 80)
    }
    
    @ViewBuilder
    func BalTotalList(size: CGSize) -> some View {
        if !balanceList.isEmpty {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(balanceList, id: \.self) { balModel in
                        BalDetaiCard(size: size, balanceModel: balModel)
                            .padding(.bottom, 15)
                            .padding(.horizontal, 20)
                    }
                }.padding(.top, 20)
                    .padding(.bottom, isTotalShow ? 140 : 90)
            }.scrollIndicators(.hidden)
        } else {
            VStack {
                Text("登録されている残高がありません。")
                    .foregroundStyle(.gray)
                RoundedButton(radius: 10, text: "残高を登録する") {
                    self.isSheetShow.toggle()
                    balanceList = viewModel.getBalnaceResults()
                }.frame(width: 120, height: 30)
            }
        }
    }
}

#Preview {
   ContentView()
}

//#Preview {
//    BalanceListPage(accentColor: .orange)
//}

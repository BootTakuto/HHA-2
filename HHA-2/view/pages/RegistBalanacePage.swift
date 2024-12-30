//
//  RegistBalanacePage.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/12/10.
//

import SwiftUI

struct RegistBalanacePage: View {
    @Binding var isPresented: Bool
    var accentColor: Color
    var accentTextColor: Color
    // 登録データ
    @State var selectedIndex = 0
    @State var balName = ""
    @State var initNum = "0"
    @State var balColorHex = "FFFFFF"
    
    // 画面制御
    @State var isRegistPopUpShow = false
    @State var isRegistSucceed = false
    @State var isColorSheetShow = false
    
    let viewModel = BalanceViewModel()
    var body: some View {
        GeometryReader { geom in
            let size = geom.size
            ZStack(alignment: .bottom) {
                Header()
                ZStack(alignment: .top) {
                    UnevenRoundedRectangle(topLeadingRadius: 10, topTrailingRadius: 10)
                        .fill(.changeable)
                        .shadow(color: .changeableShadow, radius: 5)
                    VStack(spacing: 0) {
                        Title(title: "残高追加",
                               message: "預金・ポイントなどの資産残高\nクレジットカード・ローンなどの負債残高を追加")
                        SegmentedSelector(selectedIndex: $selectedIndex, texts: ["資産", "負債"])
                            .padding(.vertical, 10)
                            .frame(width: 200)
                        // ▼残高名入力領域
                        VStack {
                            Footnote(text: selectedIndex == 0 ? "資産残高名" : "負債残高名")
                                .frame(width: size.width - 40, alignment: .leading)
                            InputText(placeHolder: "", text: $balName, isDispShadow: false)
                        }.padding(.horizontal, 10)
                            .padding(.vertical, 10)
                        // ▼初期金額設定
                        VStack {
                            Footnote(text: "初期金額")
                                .frame(width: size.width - 40, alignment: .leading)
                            InputNumWithCalc(accentColor: accentColor, inputNum: $initNum, isDispShadow: false)
                        }.padding(.horizontal, 10)
                            .padding(.vertical, 10)
                        
                        // ▼初期金額設定
                        VStack {
                            Footnote(text: "カラー")
                                .frame(width: size.width - 40, alignment: .leading)
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 0.5)
                                    .fill(.changeableStroke)
                                    .frame(height: 50)
                                HStack {
                                    Text(balColorHex)
                                    Spacer()
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .fill(.changeableStroke)
                                        .frame(width: 35, height: 35)
                                        .overlay {
                                            Circle()
                                                .fill(CommonViewModel.getColorFromHex(hex: balColorHex))
                                                .shadow(color: .changeableShadow, radius: 2)
                                                .padding(4)
                                        }
                                }.padding(.horizontal, 10)
                            }.onTapGesture {
                                //                            withAnimation {
                                self.isColorSheetShow = true
                                //                            }
                            }
                        }.padding(.horizontal, 10)
                            .padding(.vertical, 10)
                        RoundedButton(color: accentColor.opacity(balName == "" ? 0.5 : 1),
                                      text: "登 録",
                                      textColor: accentTextColor.opacity(balName == "" ? 0.5 : 1),
                                      isDispShadow: balName == "" ? false : true) {
                            // 登録データの作成
                            let balanceModel = BalanceModel()
                            balanceModel.balKey = UUID().uuidString
                            balanceModel.assetDebtFlg = selectedIndex
                            balanceModel.balName = balName
                            balanceModel.balColorHex = balColorHex
                            balanceModel.balAmount = Int(initNum) ?? 0
                            // 登録処理　成功・失敗を返す
                            self.isRegistSucceed = viewModel.reigstBalance(balanceModel: balanceModel)
                            self.isRegistPopUpShow = true
                            // 3秒ごにポップアップ非表示
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                self.isRegistPopUpShow = false
                                self.isPresented = false
                            }
                        }.disabled(balName == "")
                            .frame(height: 40)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 20)
                        Spacer()
                    }.padding(.top, 20)
                }.padding(.top, 10 + 30)
                    .sheet(isPresented: $isRegistPopUpShow) {
                        RegistPopUpCard(isSucceed: $isRegistSucceed)
                            .presentationDetents([.fraction(0.999)])
                            .padding(.horizontal, 20)
                            .presentationBackground(.clear)
                    }.floatingSheet(isPresented: $isColorSheetShow) {
                        PaletteSheet()
                            .presentationDetents([.height(350)])
                            .presentationBackgroundInteraction(.disabled)
                    }
            }.background(accentColor)
        }.ignoresSafeArea(edges: .bottom)
    }
    
    @ViewBuilder
    func Header() -> some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.isPresented = false
                }) {
                    Card(radiuses: [.infinity, .infinity, .infinity, .infinity]) {
                        HStack {
                            Footnote(text: "閉じる", color: .changeableText)
                            Image(systemName: "xmark")
                                .foregroundStyle(.changeableText)
                                .font(.footnote)
                        }
                    }
                }.foregroundStyle(accentTextColor)
                    .frame(width:100, height: 30)
            }.padding(.horizontal, 20)
            Spacer()
        }
    }
    
    @ViewBuilder
    func PaletteSheet() -> some View {
        VStack {
            Card {
                VStack(spacing: 10) {
                    Palette(hex: $balColorHex)
                        .padding(.horizontal, 10)
                    RoundedButton(text: "閉じる", textColor: .gray, isDispStroke: true, isDispShadow: false) {
                        self.isColorSheetShow = false
                    }.frame(height: 40)
                        .padding(.horizontal, 10)
                }.padding(10)
            }.padding(.horizontal, 10)
                .frame(height: 330)
        }
    }
}

#Preview {
    @Previewable @State var isPresented = false
    RegistBalanacePage(isPresented: $isPresented,
                       accentColor: .yellow,
                       accentTextColor: .black)
//    RegistBalanacePage(accentColor: .yellow,
//                       accentTextColor: .black)
}

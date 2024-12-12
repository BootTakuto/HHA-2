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
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer()
                        SegmentedSelector(selectedIndex: $selectedIndex, texts: ["資産", "負債"])
                            .frame(width: size.width * (2 / 3))
                        Spacer()
                        Button(action: {
                            self.isPresented = false
                        }) {
                            Image(systemName: "xmark")
                                .foregroundStyle(.changeableText)
                        }
                    }.padding(.horizontal, 20)
                        .padding(.leading, 15)
                    HStack {
                        VStack(alignment: .leading) {
                            Text(selectedIndex == 0 ? "資産登録" : "負債登録")
                                .font(.title2)
                                .fontWeight(.medium)
                            Footnote(text: selectedIndex == 0 ?
                                     "預金、ポイントなどの資産を登録" : "クレジットカード、奨学金などの負債を登録")
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    }.padding(20)
                    // ▼残高名入力領域
                    VStack {
                        Footnote(text: selectedIndex == 0 ? "資産残高名" : "負債残高名")
                            .frame(width: size.width - 40, alignment: .leading)
                        InputText(placeHolder: "", text: $balName, isDispShadow: false)
                    }.padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    
                    // ▼初期金額設定
                    VStack {
                        Footnote(text: "初期金額")
                            .frame(width: size.width - 40, alignment: .leading)
                        InputNumWithCalc(accentColor: accentColor, inputNum: $initNum, isDispShadow: false)
                    }.padding(.horizontal, 20)
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
                    }.padding(.horizontal, 20)
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            isRegistPopUpShow = false
                        }
                    }.disabled(balName == "")
                        .frame(height: 40)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                }
        }.padding(.top, 10)
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
}

//
//  EditBalancePage.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/12/15.
//

import SwiftUI

struct EditBalancePage: View {
    var accentColor: Color
    var accentTextColor: Color
    var balModel: BalanceModel
    // 登録データ
    @State var selectedIndex = 0
    @State var balName = ""
    @State var balAmount = "0"
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
                HStack {
                    VStack(alignment: .leading) {
                        Text("残高編集")
                            .font(.title3)
                        Footnote(text: "追加された資産・負債残高の情報を編集")
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }.padding(.horizontal, 20)
                BalanceCard()
                    .padding(.vertical, 20)
                // ▼残高名入力領域
                VStack {
                    Footnote(text: selectedIndex == 0 ? "資産残高名" : "負債残高名")
                        .frame(width: size.width - 40, alignment: .leading)
                    InputText(placeHolder: "", text: $balName, isDispShadow: false)
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
                        self.isColorSheetShow = true
                    }
                }.padding(.horizontal, 20)
                    .padding(.vertical, 10)
                RoundedButton(color: accentColor.opacity(balName == "" ? 0.5 : 1),
                              text: "変更完了",
                              textColor: accentTextColor.opacity(balName == "" ? 0.5 : 1),
                              isDispShadow: balName == "" ? false : true) {
                    // 登録データの作成
                    let balanceModel = BalanceModel()
                    balanceModel.balKey = balModel.balKey
                    balanceModel.assetDebtFlg = selectedIndex
                    balanceModel.balName = balName
                    balanceModel.balColorHex = balColorHex
                    // 登録処理　成功・失敗を返す
                    self.isRegistSucceed = viewModel.updateBalance(balModel: balanceModel)
                    self.isRegistPopUpShow = true
                    // 3秒ごにポップアップ非表示
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        isRegistPopUpShow = false
                    }
                }.disabled(balName == "")
                    .frame(height: 40)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                Spacer()
            }
        }.onAppear {
            self.selectedIndex = balModel.assetDebtFlg
            self.balName = balModel.balName
            self.balAmount = String(balModel.balAmount)
            self.balColorHex = balModel.balColorHex
        }.sheet(isPresented: $isRegistPopUpShow) {
            RegistPopUpCard(isSucceed: $isRegistSucceed)
                .presentationDetents([.fraction(0.999)])
                .padding(.horizontal, 20)
                .presentationBackground(.clear)
        }.floatingSheet(isPresented: $isColorSheetShow) {
            PaletteSheet()
                .presentationDetents([.height(350)])
                .presentationBackgroundInteraction(.disabled)
        }.padding(.top, 20)
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
    
    @ViewBuilder
    func BalanceCard() -> some View {
        Card {
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: .infinity)
                    .fill(CommonViewModel.getColorFromHex(hex: balColorHex))
                    .frame(width: 5, height: 50)
                    .padding(.trailing, 10)
                VStack {
                    Text(balName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("¥\(Int(balAmount) ?? 0)")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        CircleButton(imageNm: "plusminus",
                                     color: accentColor,
                                     textColor: accentTextColor) {
                            
                        }.frame(width: 30)
                    }
                }
            }.padding(.horizontal, 10)
        }.frame(height: 80)
            .padding(.horizontal, 20)
    }
    
}

#Preview {
//    EditBalancePage(accentColor: .yellow,
//                    accentTextColor: .black,
//                    balModel: BalanceModel())
    ContentView()
}

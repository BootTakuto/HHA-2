//
//  BalanceListPage.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/12.
//

import SwiftUI
import RealmSwift

struct BalanceListPage: View {
    var accentColor: Color = CommonViewModel.getAccentColor()
    var accentTextColor: Color = CommonViewModel.getTextColor()
    @Binding var isTotalShow: Bool
//    @State var balanceList = BalanceViewModel().getBalnaceResults()
    @ObservedResults(BalanceModel.self) var balanceList
    // 残高入力関連
    @State var isSheetShow = false
    @State var inputBalNm = ""
    @State var selectBalColorHex = "FFFFFF"
    // 画面表示設定
    @State var hiddenOffset: CGFloat = -50
    // ビューモデル
    let viewModel = BalanceViewModel()
    var body: some View {
        GeometryReader {
            let size = $0.size
            VStack(spacing: 0) {
                BalTotalHeader(size: size)
                    .zIndex(1000)
                BalTotalList(size: size)
                    .offset(y: isTotalShow ? 0 : hiddenOffset)
                    .frame(height: size.height)
            }.floatingSheet(isPresented: $isSheetShow) {
                RegistBalancePopUp(size: size)
                    .presentationDetents([.fraction(0.999)])
                    .padding(.horizontal, 20)
            }
        }
    }
    
    @ViewBuilder
    func BalTotalHeader(size: CGSize) -> some View {
        InnerHeader(isShow: $isTotalShow, hiddenOffset: hiddenOffset, height: 80) {
            HStack(spacing: 0) {
                Text("合計")
                    .frame(width: size.width / 2 - 10, alignment: .leading)
                    .padding(.leading, 10)
                Text("¥\(0)")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(width: size.width / 2 - 50, alignment: .trailing)
                CircleButton(imageNm: "plus") {
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
        Card {
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: .infinity)
                    .fill(CommonViewModel.getColorFromHex(hex: balanceModel.balColorHex))
                    .frame(width: 5, height: 60)
                VStack {
                    HStack(spacing: 0) {
                        Text(balanceModel.balName)
                            .padding(.leading, 10)
                            .lineLimit(1)
                        Spacer()
                    }
                    HStack(spacing: 0) {
                        Spacer()
                        Text("¥\(balanceModel.balAmount)")
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
                            .padding(.horizontal, 15)
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
                }.frame(width: 120, height: 30)
            }
        }
    }
    
    @ViewBuilder
    func RegistBalancePopUp(size: CGSize) -> some View {
        Card {
            VStack(spacing: 0) {
                Text("残高情報の登録")
                    .foregroundStyle(.changeableText)
                    .padding(.bottom, 5)
                    .padding(.top, 10)
                Footnote(text: "残高")
                    .frame(width: size.width - 60, alignment: .leading)
                    .padding(.bottom, 5)
                InputText(placeHolder: "20文字以内", text: $inputBalNm, isDispShadow: false)
                    .padding(.bottom, 10)
                HStack {
                    Footnote(text: "タグ")
                    Spacer()
                    Circle()
                        .fill(CommonViewModel.getColorFromHex(hex: selectBalColorHex))
                        .frame(width: 25, height: 25)
                        .shadow(color: .changeableShadow, radius: 3)
                        .padding(.trailing, 5)
                }.padding(.bottom, 5)
                ScrollView {
                    VStack {
                        Palette(hex: $selectBalColorHex)
                    }.frame(height: 320)
                }.clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(height: 150)
                    .scrollIndicators(.hidden)
                    .padding(.bottom, 10)
                RegistButton(text: "登録", isDisabled: inputBalNm.isEmpty) {
                    let balanceModel = BalanceModel()
                    balanceModel.balKey = UUID().uuidString
                    balanceModel.balName = inputBalNm
                    balanceModel.balColorHex = selectBalColorHex
                    viewModel.reigstBalance(balanceModel: balanceModel)
                    self.isSheetShow.toggle()
                }.frame(height: 40)
                    .padding(.bottom, 5)
                CancelButton(text: "閉じる") {
                    self.isSheetShow.toggle()
                }.frame(height: 40)
            }.padding(.horizontal, 10)
                .frame(height: 400, alignment: .top)
        }.frame(height: 400)
    }
}

#Preview {
   ContentView()
}

//#Preview {
//    BalanceListPage(accentColor: .orange)
//}

//
//  InputPage.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/19.
//

import SwiftUI

struct InputPage: View {
    // 共通プロパティ
    var accentColor: Color = CommonViewModel.getAccentColor()
    var accentTextColor: Color = CommonViewModel.getTextColor()
    @Binding var isPresented: Bool
    @State var selectedIndex = 0
    @State var isLinkBal = false
    @State var date = Date()
    @State var memo = ""
    // モーダル表示フラグ
    @State var isSheetShow = false
    // 残高未連携　入力情報
    @State var unLinkInputAmt = "0"
    // 残高連携　入力情報
    @State var linkBalArray = [LinkBalanaceData]() // 表示用
    @State var selectBalArray = [LinkBalanaceData]() // 登録用
    @State var dic:[Int: String] = [0: "0", 1: "1", 2: "2"]
    // 画面表示設定
    @State var isShowInnerHeader = true
    @State var hiddenOffset: CGFloat = -90
    // ビューモデル
    var viewModel = InputPageVeiwModel()
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeAreaInsets = $0.safeAreaInsets
            let isSelectIncome = selectedIndex == 0 ? true : false
            VStack(spacing: 0) {
                Header(size: size, safeAreaInsets: safeAreaInsets, isSelectIncome: isSelectIncome)
                    .zIndex(1000)
                ScrollView {
                    InputAmt(size: size, isSelectedIncome: isSelectIncome)
                        .padding(.top, 15)
                    Sections(size: size, isSelectedIncome: isSelectIncome)
                    SelectDate(size: size)
                    Memo(size: size)
                    RegistButton(text: "登録") {
                        
                    }.frame(height: 40)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                }.offset(y: isShowInnerHeader ? 0 : hiddenOffset)
            }.ignoresSafeArea()
                .onAppear {
                    self.linkBalArray = viewModel.getLinkBalArray()
                }.floatingSheet(isPresented: $isSheetShow) {
                    SelectBalCheckList(size: size)
                        .presentationDetents([.height(300)])
                        .presentationBackgroundInteraction(.enabled(upThrough: .height(300)))
                }
        }
    }
    
    @ViewBuilder
    func Header(size: CGSize, safeAreaInsets: EdgeInsets, isSelectIncome: Bool) -> some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(.changeable)
                UnevenRoundedRectangle(bottomLeadingRadius: 20)
                    .fill(accentColor)
                VStack {
                    Spacer()
                        .frame(height: safeAreaInsets.top - 5)
                    HStack {
                        Text("入力")
                            .font(.title3)
                            .fontWeight(.medium)
                        Button(action: {
                            
                        }) {
                            Image(systemName: "questionmark.circle")
                        }
                        Spacer()
                        Button(action: {
                            self.isPresented = false
                        }) {
                            Image(systemName: "xmark")
                        }
                    }.padding(.horizontal, 30)
                        .foregroundStyle(accentTextColor)
                }
            }.frame(height:  safeAreaInsets.top + 30)
                .zIndex(100)
            InnerHeader(isShow: $isShowInnerHeader, isAbleShrink: false, hiddenOffset: 0, height: 50) {
                SegmentedSelector(selectedIndex: $selectedIndex, texts: ["収入", "支出"])
                    .frame(width: 200)
                    .padding(.vertical, 10)
            }
        }
    }
    
    @ViewBuilder
    func LinkBalToggle(isSelectedIncome: Bool) -> some View {
        HStack {
            Footnote(text: isSelectedIncome ? "収入を残高と連携" : "支出を残高と連携")
            Spacer()
            CustomToggle(isOn: $isLinkBal, color: accentColor)
        }
    }
    
    @ViewBuilder
    func InputAmt(size: CGSize, isSelectedIncome: Bool) -> some View {
        VStack {
            Footnote(text: isSelectedIncome ? "収入額" : "支出額")
                .frame(width: size.width - 40, alignment: .leading)
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.changeable)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 0.5)
                            .fill(.changeableStroke)
                    }
                VStack(spacing: 0) {
                    LinkBalToggle(isSelectedIncome: isSelectedIncome)
                    if isLinkBal {
                        InputAmtLinkBal(size: size, isSelectedIncome: isSelectedIncome)
                            .frame(height: selectBalArray.isEmpty ? 80 : 170)
                    } else {
                        InputNumWithCalc(accentColor: accentColor, inputNum: $unLinkInputAmt, isDispStroke: false)
                            .frame(height: 80)
                    }
                }.padding(.horizontal, 10)
                    .padding(.vertical, 10)
            }
        }.padding(.horizontal, 20)
            .padding(.vertical, 5)
    }
    
    @ViewBuilder
    func InputAmtLinkBal(size: CGSize, isSelectedIncome: Bool) -> some View {
        VStack(spacing: 0) {
            if selectBalArray.isEmpty {
                RoundedButton(radius: 10, text: "連携する残高を選択してください。",
                              font: .footnote, textColor: .gray, shadwoRadius: 5) {
                    self.isSheetShow.toggle()
                }.frame(width: 250, height: 40)
            } else {
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach (selectBalArray.indices, id: \.self) { index in
                            let linkBalModel = selectBalArray[index]
                            let balNm = linkBalModel.balModel.balName
                            let balAmt = linkBalModel.balModel.balAmount
                            let tagColor = CommonViewModel.getColorFromHex(hex: linkBalModel.balModel.balColorHex)
                            Card(shadowColor: .changeableShadow.opacity(0.5), shadowRadius: 5) {
                                GeometryReader { local in
                                    VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                            let width = local.size.width
                                            RoundedRectangle(cornerRadius: .infinity)
                                                .fill(tagColor)
                                                .frame(width: 5, height: 30)
                                            Footnote(text: balNm)
                                                .frame(width: width / 2 - 20)
                                                .lineLimit(1)
                                                .padding(.horizontal, 2.5)
                                            Border()
                                                .frame(height: 20)
                                                .padding(.horizontal, 5)
                                            Footnote(text: "¥\(balAmt)")
                                                .frame(width: width / 2 - 20)
                                                .lineLimit(1)
                                        }.padding(.vertical, 10)
                                            .frame(height: 50)
                                        InputNumWithCalc(accentColor: accentColor,
                                                         inputNum: $selectBalArray[index].inputAmt, isDispShadow: false)
                                            .padding(.horizontal, 10)
                                    }
                                }
                            }.frame(width: 310, height: 110)
                        }
                    }.scrollTargetLayout()
                        .padding(.horizontal, 15)
                }.scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                RoundedButton(radius: 10, text: "残高を選択",
                              font: .footnote, textColor: .gray, shadwoRadius: 5) {
                    self.isSheetShow.toggle()
                }.frame(width: 150, height: 30)
            }
        }
    }
    
    @ViewBuilder
    func SelectBalCheckList(size: CGSize) -> some View {
        let rowCount = linkBalArray.count % 3 > 0 ? linkBalArray.count + (3 - linkBalArray.count) : linkBalArray.count
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.changeable)
                .padding(.top, 10)
                .shadow(color: .changeableShadow, radius: 5)
            if linkBalArray.isEmpty {
                VStack {
                    Footnote(text: "残高が存在しません。")
                    RoundedButton(radius: 10, text: "残高を追加する") {
                        
                    }.frame(width: 100, height: 30)
                }
            } else {
                ScrollView {
                    VStack {
                        ForEach(0 ..< rowCount, id: \.self) { row in
                            HStack(spacing: 3) {
                                ForEach(0 ..< 3, id: \.self) { col in
                                    let index = CommonViewModel.getRowColIndex(col, row, 3)
                                    ZStack {
                                        Rectangle()
                                            .fill(.clear)
                                        if linkBalArray.count > index {
                                            let linkBalModel = linkBalArray[index]
                                            let balModel = linkBalModel.balModel
                                            CheckBox(text: balModel.balName) {
                                                if !selectBalArray.contains(where: {$0.balModel.balKey == balModel.balKey}) {
                                                    self.selectBalArray.append(linkBalModel)
                                                } else {
                                                    self.selectBalArray.removeAll(where: {$0.balModel.balKey == balModel.balKey})
                                                }
                                            }
                                        }
                                    }.frame(width: size.width / 3 - 10)
                                        .padding(.bottom, 10)
                                        .padding(.horizontal, 1)
                                }
                            }
                        }
                    }.padding(.top, 10)
                }.frame(height: 280)
                    .scrollIndicators(.hidden)
            }
        }.ignoresSafeArea()
            
    }
    
    @ViewBuilder
    func Sections(size: CGSize,  isSelectedIncome: Bool) -> some View {
//        let isIncome = selectedIndex == 0
        VStack {
            Footnote(text: isSelectedIncome ? "収入カテゴリー" : "支出カテゴリー")
                .frame(width: size.width - 40, alignment: .leading)
            SectionSelector(selectIndex: $selectedIndex, isDispShadow: false)
        }.padding(.horizontal, 20)
            .padding(.vertical, 5)
    }
    
    @ViewBuilder
    func SelectDate(size: CGSize) -> some View {
        VStack {
            Footnote(text: "日付")
                .frame(width: size.width - 40, alignment: .leading)
            DateSelector(selectDate: $date, isDispShadow: false)
        }.padding(.horizontal, 20)
            .padding(.vertical, 5)
    }
    
    @ViewBuilder
    func Memo(size: CGSize) -> some View {
        VStack {
            Footnote(text: "メモ")
                .frame(width: size.width - 40, alignment: .leading)
            InputText(placeHolder: "50文字以内", text: $memo, isDispShadow: false)
        }.padding(.horizontal, 20)
            .padding(.vertical, 5)
    }
}

#Preview {
    @Previewable @State var isPresented = false
    InputPage(isPresented: $isPresented)
}
//#Preview {
//    ContentView()
//}

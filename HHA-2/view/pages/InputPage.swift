//
//  InputPage.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/19.
//

import SwiftUI

struct InputPage: View {
    // 共通プロパティ
    var accentColor: Color
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
    @State var linkBalArray = [LinkBalanaceData]()
    @State var selectBalKeyArray = [String]()
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
                SegmentedSelector(accentColor: accentColor, selectedIndex: $selectedIndex, texts: ["収入", "支出"])
                    .frame(width: 200)
                    .padding(.vertical, 10)
                ScrollView {
                    InputAmt(size: size, isSelectedIncome: isSelectIncome)
                        .padding(.top, 10)
                    Sections(size: size, isSelectedIncome: isSelectIncome)
                    SelectDate(size: size)
                    Memo(size: size)
                    RoundedButton(radius: 10, color: accentColor, text: "登録", font: .body, shadwoRadius: 5) {
                        
                    }.frame(width: 180, height: 40)
                        .padding(.vertical, 10)
                }.offset(y: isShowInnerHeader ? 0 : hiddenOffset)
            }.ignoresSafeArea()
                .onAppear {
                    self.linkBalArray = viewModel.getLinkBalArray()
                }.floatingSheet(isPresented: $isSheetShow) {
                    SelectBalList(size: size)
                        .presentationDetents([.height(300)])
                        .presentationBackgroundInteraction(.enabled(upThrough: .height(300)))
                }
        }
    }
    
    @ViewBuilder
    func Header(size: CGSize, safeAreaInsets: EdgeInsets, isSelectIncome: Bool) -> some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: isShowInnerHeader ? 0 : 20)
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
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                    Button(action: {
                        self.isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundStyle(.gray)
                    }
                }.padding(.horizontal, 30)
            }
        }.frame(height:  safeAreaInsets.top + 30)
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
                            .frame(height: selectBalKeyArray.isEmpty ? 70 : 180)
                            .padding(.bottom, 10)
                    } else {
                        InputNumWithCalc(accentColor: accentColor, inputNum: $unLinkInputAmt, isDispStroke: false)
                            .frame(height: 90)
                    }
                }.padding(.horizontal, 10)
                    .padding(.vertical, 10)
            }
        }.padding(.horizontal, 20)
            .padding(.vertical, 5)
    }
    
    @ViewBuilder
    func InputAmtLinkBal(size: CGSize, isSelectedIncome: Bool) -> some View {
        VStack {
            if selectBalKeyArray.isEmpty {
                RoundedButton(radius: 10, text: "連携する残高を選択してください。",
                              font: .footnote, textColor: .gray, shadwoRadius: 5) {
                    self.isSheetShow.toggle()
                }.frame(width: 250, height: 40)
            } else {
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach (selectBalKeyArray.indices, id: \.self) { index in
                            let balModel = viewModel.getBalModelByKey(balKey: selectBalKeyArray[index])
                            let balNm = balModel.balName
                            let balAmt = balModel.balAmount
                            Card(shadowColor: .changeableShadow.opacity(0.5), shadowRadius: 10) {
                                GeometryReader { local in
                                    VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                            let width = local.size.width
                                            RoundedRectangle(cornerRadius: .infinity)
                                                .fill(.orange)
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
                                        InputNumWithCalc(accentColor: accentColor, inputNum: $unLinkInputAmt, isDispShadow: false)
                                            .padding(.horizontal, 10)
                                    }
                                }
                            }.frame(width: 310, height: 110)
                        }
                    }.scrollTargetLayout()
                        .padding(.horizontal, 16)
                } .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                RoundedButton(radius: 10, text: "残高を選択",
                              font: .footnote, textColor: .gray, shadwoRadius: 10) {
                    self.isSheetShow.toggle()
                }.frame(width: 150, height: 30)
            }
        }
    }
    
    @ViewBuilder
    func SelectBalList(size: CGSize) -> some View {
        let balCount = linkBalArray.count % 3 > 0 ? linkBalArray.count + (3 - linkBalArray.count) : linkBalArray.count
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
                        ForEach(0 ..< balCount, id: \.self) { col in
                            HStack(spacing: 3) {
                                ForEach(0 ..< 3, id: \.self) { row in
                                    let index = row + (col * 3)
                                    ZStack {
                                        Rectangle()
                                            .fill(.clear)
                                        if linkBalArray.count > index {
                                            let balModel = linkBalArray[index].balModel
                                            CheckBox(isChecked: $linkBalArray[index].isSelected,
                                                     accentColor: accentColor, text: balModel.balName)
                                            .onChange(of: linkBalArray[index].isSelected) {
                                                withAnimation {
                                                    if !selectBalKeyArray.contains(balModel.balKey) {
                                                        self.selectBalKeyArray.append(balModel.balKey)
                                                    } else {
                                                        self.selectBalKeyArray.removeAll(where: {$0 == balModel.balKey})
                                                    }
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
    InputPage(accentColor: .orange, isPresented: $isPresented)
}
//#Preview {
//    ContentView()
//}

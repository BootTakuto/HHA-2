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
    // 残高未連携　入力情報
    @State var unLinkInputAmt = "0"
    // 残高連携　入力情報
//    @State var
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeAreaInsets = $0.safeAreaInsets
            let isSelectIncome = selectedIndex == 0 ? true : false
            VStack(spacing: 0) {
                Header(size: size, safeAreaInsets: safeAreaInsets)
                    .zIndex(1000)
                SegmentedSelector(accentColor: accentColor, selectedIndex: $selectedIndex, texts: ["収入", "支出"])
                    .frame(width: 200)
                    .padding(.vertical, 10)
                ScrollView {
                    LinkBalToggle()
                    if isLinkBal {
                        BalSelector(size: size, isSelectedIncome: isSelectIncome)
                        InputAmtLinkBal(size: size, isSelectedIncome: isSelectIncome)
                    } else {
                        InputAmtUnLinkBal(size: size, isSelectedIncome: isSelectIncome)
                    }
                    Sections(size: size, isSelectedIncome: isSelectIncome)
                    SelectDate(size: size)
                    Memo(size: size)
                    RoundedButton(radius: .infinity, color: accentColor, text: "登録", font: .body, shadwoRadius: 5) {
                        
                    }.frame(width: 150, height: 40)
                        .padding(.vertical, 10)
                }
            }.ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func Header(size: CGSize, safeAreaInsets: EdgeInsets) -> some View {
        ZStack(alignment: .topLeading) {
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
    func LinkBalToggle() -> some View {
        HStack {
            Footnote(text: "残高と連携")
            Spacer()
            CustomToggle(isOn: $isLinkBal, color: accentColor)
        }.padding(.horizontal, 20)
            .padding(.top, 5)
    }
    
    @ViewBuilder
    func InputAmtUnLinkBal(size: CGSize, isSelectedIncome: Bool) -> some View {
        VStack {
            Footnote(text: isSelectedIncome ? "収入額" : "支出額")
                .frame(width: size.width - 40, alignment: .leading)
            InputNumWithCalc(accentColor: accentColor, inputNum: $unLinkInputAmt)
        }.padding(.horizontal, 20)
            .padding(.vertical, 5)
    }
    
    @ViewBuilder
    func BalSelector(size: CGSize, isSelectedIncome: Bool) -> some View {
        VStack {
            Footnote(text: "連携する残高を選択（複数選択可）")
                .frame(width: size.width - 40, alignment: .leading)
            
        }.padding(.horizontal, 20)
            .padding(.vertical, 5)
    }
    
    @ViewBuilder
    func InputAmtLinkBal(size: CGSize, isSelectedIncome: Bool) -> some View {
        VStack {
            Footnote(text: isSelectedIncome ? "収入額" : "支出額")
                .frame(width: size.width - 40, alignment: .leading)
            
        }.padding(.horizontal, 20)
            .padding(.vertical, 5)
    }
    
    @ViewBuilder
    func Sections(size: CGSize,  isSelectedIncome: Bool) -> some View {
        VStack {
            Footnote(text: isSelectedIncome ? "収入カテゴリー" : "支出カテゴリー")
                .frame(width: size.width - 40, alignment: .leading)
            SectionSelector(selectIndex: $selectedIndex)
        }.padding(.horizontal, 20)
            .padding(.vertical, 5)
    }
    
    @ViewBuilder
    func SelectDate(size: CGSize) -> some View {
        VStack {
            Footnote(text: "日付")
                .frame(width: size.width - 40, alignment: .leading)
            DateSelector(selectDate: $date)
        }.padding(.horizontal, 20)
            .padding(.vertical, 5)
    }
    
    @ViewBuilder
    func Memo(size: CGSize) -> some View {
        VStack {
            Footnote(text: "メモ")
                .frame(width: size.width - 40, alignment: .leading)
            InputText(placeHolder: "50文字以内", text: $memo)
        }.padding(.horizontal, 20)
            .padding(.vertical, 5)
    }
}

#Preview {
    @Previewable @State var isPresented = false
    InputPage(accentColor: .orange, isPresented: $isPresented)
}

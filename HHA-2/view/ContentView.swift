//
//  ContentView.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/12.
//
import SwiftUI

struct ContentView: View {
    @State var pageIndex = 0
    @State var isHeaderShow = true
    @State var isInputShow = false
    @State var accentColor = CommonViewModel.getAccentColor()
    @State var accentTextColor = CommonViewModel.getTextColor()
    let pageNames = ["残高一覧", "収入・支出", "カレンダー", "メニュー"]
    var body: some View {
        NavigationStack {
            GeometryReader {
                let size = $0.size
                let safeAreaInsets = $0.safeAreaInsets
                VStack(spacing: 0) {
                    Header(size: size, safeAreaInsets: safeAreaInsets)
                        .zIndex(1000)
                    ZStack(alignment: .bottom) {
                        switch pageIndex {
                        case 0:
                            BalanceListPage(isTotalShow: $isHeaderShow)
                        case 1:
                            IncomeConsumePage(isTotalShow: $isHeaderShow)
                        case 2:
                            CalendarPage(isCalendarShow: $isHeaderShow)
                        case 3:
                            MenuPage(accentColor: $accentColor,
                                     accentTextColor: $accentTextColor)
                        default:
                            BalanceListPage(isTotalShow: $isHeaderShow)
                        }
                        InputAmountButton()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal, 10)
                            .padding(.bottom, 10)
                    }
                    CustomTab(accentColor: accentColor,
                              accentTextColor: accentTextColor,
                              pageIndex: $pageIndex,
                              pageNames: pageNames)
                    Rectangle()
                        .fill(.changeable)
                        .frame(height: safeAreaInsets.bottom)
                }.ignoresSafeArea()
            }.onChange(of: pageIndex) {
                withAnimation {
                    self.isHeaderShow = true
                }
            }.fullScreenCover(isPresented: $isInputShow) {
                InputPage(accentColor: accentColor, isPresented: $isInputShow)
            }.onAppear {
                let realm = CommonViewModel().realm
                print(realm.configuration.fileURL!)
            }
        }
    }
    
    @ViewBuilder
    func Header(size: CGSize, safeAreaInsets: EdgeInsets) -> some View {
        ZStack(alignment: isHeaderShow ? .leading : .center) {
            RoundedRectangle(cornerRadius: isHeaderShow ? 0 : 20)
                .fill(.changeable)
            UnevenRoundedRectangle(bottomLeadingRadius: 20)
                .fill(accentColor)
            VStack {
                Spacer()
                    .frame(height: safeAreaInsets.top - 5)
                HStack {
                    Text(pageNames[pageIndex])
                        .font(isHeaderShow ? .title3 : .subheadline)
                        .fontWeight(.medium)
                    if isHeaderShow {
                        Button(action: {
                            
                        }) {
                            Image(systemName: "questionmark.circle")
                        }
                    }
                }.padding(.horizontal, 30)
                    .foregroundStyle(accentTextColor)
            }
        }.frame(height:  isHeaderShow ?  safeAreaInsets.top + 50 : safeAreaInsets.top)
    }
    
    @ViewBuilder
    func InputAmountButton() -> some View {
        CircleButton(text: "入力", imageNm: "square.and.pencil") {
            self.isInputShow = true
        }.frame(width: 60)
    }
}

#Preview {
    ContentView()
}

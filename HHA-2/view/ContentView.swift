//
//  ContentView.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/12.
//
import SwiftUI

struct ContentView: View {
    @AppStorage("ACCENT_COLOR") var accentColorIndex: Int = 0
    @State var accentColor = Color.blue
    @State var pageIndex = 0
    @State var isHeaderShow = true
    @State var isInputShow = false
    let pageNames = ["残高一覧", "入出金", "カレンダー", "メニュー"]
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeAreaInsets = $0.safeAreaInsets
            VStack(spacing: 0) {
                Header(size: size, safeAreaInsets: safeAreaInsets)
                    .zIndex(1000)
                ZStack(alignment: .bottom) {
                    switch pageIndex {
                    case 0:
                        BalanceListPage(accentColor: accentColor,
                                        isTotalShow: $isHeaderShow)
                    case 1:
                        DepositWithdrawPage(isTotalShow: $isHeaderShow)
                    case 2:
                        CalendarPage(isCalendarShow: $isHeaderShow)
                    case 3:
                        MenuPage()
                    default:
                        BalanceListPage(accentColor: accentColor,
                                        isTotalShow: $isHeaderShow)
                    }
                    InputAmountButton()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                }
                CustomTab(accentColor: accentColor, pageIndex: $pageIndex, pageNames: pageNames)
                Rectangle()
                    .fill(.changeable)
                    .frame(height: safeAreaInsets.bottom)
            }.ignoresSafeArea()
        }.onAppear {
            self.accentColor = CommonModel.colors[accentColorIndex]
        }.onChange(of: pageIndex) {
            withAnimation {
                self.isHeaderShow = true
            }
        }.fullScreenCover(isPresented: $isInputShow) {
            InputPage(accentColor: accentColor, isPresented: $isInputShow)
        }
    }
    
    @ViewBuilder
    func Header(size: CGSize, safeAreaInsets: EdgeInsets) -> some View {
        ZStack(alignment: isHeaderShow ? .topLeading : .center) {
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
                                .foregroundStyle(.gray)
                        }
                    }
                }.padding(.horizontal, 30)
            }
        }.frame(height:  isHeaderShow ?  safeAreaInsets.top + 30 : safeAreaInsets.top)
    }
    
    @ViewBuilder
    func InputAmountButton() -> some View {
        Button(action: {
            self.isInputShow = true
        }) {
            Circle()
                .fill(accentColor)
                .overlay {
                    VStack(spacing: 2) {
                        Image(systemName: "square.and.pencil")
                        Text("入力")
                            .font(.system(size: 10))
                    }.foregroundStyle(.changeableText)
                }
                .frame(width: 60)
                .compositingGroup()
                .shadow(color: .changeableShadow, radius: 5)
        }
            
    }
}

#Preview {
    ContentView()
}

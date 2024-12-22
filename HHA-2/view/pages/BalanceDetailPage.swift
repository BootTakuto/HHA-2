//
//  BalanceDetailPage.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/12/06.
//

import SwiftUI
import RealmSwift

struct BalanceDetailPage: View {
    @Binding var isPresented: Bool
    var accentColor: Color
    var accentTextColor: Color
    @State var balModel: BalanceModel
    // 画面表示設定
    @State var selectedPageIndex = 0
    @State var isEditMode = false
    @State var selectedDate = Date()
    @State var isDeleteAlertShow = false
    let viewModel = BalanceViewModel()
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Header()
                ZStack(alignment: .top) {
                    UnevenRoundedRectangle(topLeadingRadius: 0, topTrailingRadius: 10)
                        .fill(.changeable)
                        .shadow(color: .changeableShadow, radius: 5)
                    switch selectedPageIndex {
                    case 0:
                        BalanceLinkHistoryPage()
                    case 1:
                        EditBalancePage(accentColor: accentColor,
                                        accentTextColor: accentTextColor,
                                        balModel: balModel)
                    default:
                        BalanceLinkHistoryPage()
                    }
                }.padding(.top, 10 + 30)
                HStack(spacing: 15) {
//                    RoundedTab(selectIndex: $selectedPageIndex,
//                               tabDatas: [TabData(title: "連携一覧", iconNm: "list.bullet"),
//                                          TabData(title: "編集", iconNm: "square.and.pencil")],
//                               accentColor: accentColor, accentTextColor: accentTextColor,
//                               scrollViewProxy: )
                    CircleButton(imageNm: "trash", color: .changeable, textColor: .red) {
                        self.isDeleteAlertShow = true
                    }.frame(width: 40)
                }.padding(.bottom, 30)
            }.background(accentColor)
                .ignoresSafeArea(edges: .bottom)
        }.navigationBarBackButtonHidden()
            .floatingSheet(isPresented: $isDeleteAlertShow) {
                AlertPopUpCard(isPresented: $isDeleteAlertShow,
                               message: "この残高を削除します。よろしいですか？\n※この残高の連携収支・金額等の情報の一切が削除されます。") {
                    self.isDeleteAlertShow = false
                    self.isPresented = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        viewModel.deleteBalanceModel(balKey: balModel.balKey)
                    }
                }.presentationDetents([.fraction(0.999)])
            }
    }
    
    @ViewBuilder
    func Header() -> some View {
        VStack {
            HStack {
                Button(action: {
                    self.isPresented = false
                }) {
                    HStack {
                        Card(radiuses: [.infinity, .infinity, .infinity, .infinity]) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(.changeableText)
                                    .font(.footnote)
                                Footnote(text: "戻る", color: .changeableText)
                            }
                        }
                    }
                }.frame(width: 100, height: 30)
                Spacer()
            }.padding(.horizontal, 10)
            Spacer()
        }
    }
//    @ViewBuilder
//    func Header(size: CGSize, safeAreaInsets: EdgeInsets) -> some View {
//        VStack(spacing: 0) {
//            ZStack(alignment: isHeaderShow ? .leading : .center) {
//                RoundedRectangle(cornerRadius: isHeaderShow ? 0 : 20)
//                    .fill(.changeable)
//                UnevenRoundedRectangle(bottomTrailingRadius: 20)
//                    .fill(accentColor)
//                VStack {
//                    Spacer()
//                        .frame(height: max(safeAreaInsets.top - 5, 0))
//                    HStack(spacing: 0) {
//                        Button(action: {
//                            self.isPresented = false
//                        }) {
//                            Image(systemName: "chevron.left")
//                                .fontWeight(.medium)
//                                .foregroundStyle(accentTextColor)
//                        }
//                        HStack {
//                            Text("残高詳細")
//                                .font(isHeaderShow ? .title3 : .subheadline)
//                                .fontWeight(.medium)
//                            if isHeaderShow {
//                                Button(action: {
//                                    
//                                }) {
//                                    Image(systemName: "questionmark.circle")
//                                }
//                            }
//                        }.frame(maxWidth: size.width, alignment: .center)
//                        if isHeaderShow {
//                            if isEditMode {
//                            } else {
//                                Menu {
//                                    Button(action: {
//                                        
//                                    }) {
//                                        Text("編集")
//                                        Image(systemName: "pencil")
//                                    }
//                                    Button(role: .destructive, action: {
//                                        
//                                    }) {
//                                        Text("削除")
//                                        Image(systemName: "trash")
//                                    }
//                                } label: {
//                                    Image(systemName: "ellipsis")
//                                        .fontWeight(.medium)
//                                        .foregroundStyle(accentTextColor)
//                                }
//                            }
//                        } else {
//                            Spacer()
//                                .frame(width: 15)
//                        }
//                        
//                    }.padding(.horizontal, 20)
//                        .foregroundStyle(accentTextColor)
//                }
//            }.frame(height:  isHeaderShow ?  safeAreaInsets.top + 50 : safeAreaInsets.top)
//                .zIndex(1000)
//            InnerHeader(isShow: $isHeaderShow, isAbleShrink: false, hiddenOffset: 0, height: 80) {
//                HStack(spacing: 0) {
//                    RoundedRectangle(cornerRadius: .infinity)
//                        .fill(CommonViewModel.getColorFromHex(hex: balModel.balColorHex))
//                        .frame(width: 5, height: 30)
//                    VStack {
//                        HStack(spacing: 0) {
//                            Text(balModel.balName)
//                                .padding(.leading, 15)
//                                .lineLimit(1)
//                            Spacer()
//                        }
//                        HStack(spacing: 0) {
//                            Spacer()
//                            Text("¥\(balModel.balAmount)")
//                                .lineLimit(1)
//                                .foregroundStyle(balModel.balAmount < 0 ? .red : .changeableText)
//                        }
//                    }
//                }.padding(.horizontal, 20)
//            }
//        }
//    }
    
//    @ViewBuilder
//    func MovementList() -> some View {
//        YearMonthSelector(targetDate: $selectedDate)
//        .padding(.horizontal, 10)
//    }
}

#Preview {
    @Previewable @State var isPresented = false
//    @Previewable @State var allBalDic = BalanceViewModel().getBalanceDic()
    BalanceDetailPage(isPresented: $isPresented,
                      accentColor: .yellow,
                      accentTextColor: .black,
                      balModel: BalanceModel())
}

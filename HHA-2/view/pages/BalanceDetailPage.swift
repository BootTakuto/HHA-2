//
//  BalanceDetailPage.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/12/06.
//

import SwiftUI

struct BalanceDetailPage: View {
    @Binding var isPresented: Bool
    var accentColor: Color
    var accentTextColor: Color
    @State var balModel: BalanceModel
    // 画面表示設定
    @State var isHeaderShow = true
    @State var isEditMode = false
    @State var selectedDate = Date()
    var body: some View {
        NavigationStack {
            GeometryReader { geom in
                VStack(spacing: 0) {
                    Header(size: geom.size, safeAreaInsets: geom.safeAreaInsets)
                    MovementList()
                        .padding(.vertical, 15)
                }.ignoresSafeArea()
            }
        }.navigationBarBackButtonHidden()
    }
    
    @ViewBuilder
    func Header(size: CGSize, safeAreaInsets: EdgeInsets) -> some View {
        VStack(spacing: 0) {
            ZStack(alignment: isHeaderShow ? .leading : .center) {
                RoundedRectangle(cornerRadius: isHeaderShow ? 0 : 20)
                    .fill(.changeable)
                UnevenRoundedRectangle(bottomTrailingRadius: 20)
                    .fill(accentColor)
                VStack {
                    Spacer()
                        .frame(height: max(safeAreaInsets.top - 5, 0))
                    HStack(spacing: 0) {
                        Button(action: {
                            self.isPresented = false
                        }) {
                            Image(systemName: "chevron.left")
                                .fontWeight(.medium)
                                .foregroundStyle(accentTextColor)
                        }
                        HStack {
                            Text("残高詳細")
                                .font(isHeaderShow ? .title3 : .subheadline)
                                .fontWeight(.medium)
                            if isHeaderShow {
                                Button(action: {
                                    
                                }) {
                                    Image(systemName: "questionmark.circle")
                                }
                            }
                        }.frame(maxWidth: size.width, alignment: .center)
                        if isHeaderShow {
                            if isEditMode {
                            } else {
                                Menu {
                                    Button(action: {
                                        
                                    }) {
                                        Text("編集")
                                        Image(systemName: "pencil")
                                    }
                                    Button(role: .destructive, action: {
                                        
                                    }) {
                                        Text("削除")
                                        Image(systemName: "trash")
                                    }
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .fontWeight(.medium)
                                        .foregroundStyle(accentTextColor)
                                }
                            }
                        } else {
                            Spacer()
                                .frame(width: 15)
                        }
                        
                    }.padding(.horizontal, 20)
                        .foregroundStyle(accentTextColor)
                }
            }.frame(height:  isHeaderShow ?  safeAreaInsets.top + 50 : safeAreaInsets.top)
                .zIndex(1000)
            InnerHeader(isShow: $isHeaderShow, isAbleShrink: false, hiddenOffset: 0, height: 80) {
                HStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: .infinity)
                        .fill(CommonViewModel.getColorFromHex(hex: balModel.balColorHex))
                        .frame(width: 5, height: 30)
                    VStack {
                        HStack(spacing: 0) {
                            Text(balModel.balName)
                                .padding(.leading, 15)
                                .lineLimit(1)
                            Spacer()
                        }
                        HStack(spacing: 0) {
                            Spacer()
                            Text("¥\(balModel.balAmount)")
                                .lineLimit(1)
                                .foregroundStyle(balModel.balAmount < 0 ? .red : .changeableText)
                        }
                    }
                }.padding(.horizontal, 20)
            }
        }
    }
    
    @ViewBuilder
    func MovementList() -> some View {
        YearMonthSelector(targetDate: $selectedDate)
        .padding(.horizontal, 10)
    }
}

#Preview {
    @Previewable @State var isPresented = false
    BalanceDetailPage(isPresented: $isPresented,
                      accentColor: .yellow,
                      accentTextColor: .black,
                      balModel: BalanceModel())
}

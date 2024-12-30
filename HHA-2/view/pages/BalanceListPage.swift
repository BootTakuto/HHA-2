//
//  BalanceListPage.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/12.
//

import SwiftUI
import RealmSwift

struct BalanceListPage: View {
    @Binding var isRegistPagePresented: Bool
    var accentColor: Color
    var accentTextColor: Color
    // 表示データ
    @State var balTotalDic = BalanceViewModel().getBalTotalDic()
    @State var dispInfoIndex = 0
    @State var allBalDataDic = BalanceViewModel().getBalanceDic()
    @State var dispBalDataDic = [Int: Results<BalanceModel>]()
    var titles = [TabData(title: "資産・負債一覧", iconNm: "list.bullet"),
                  TabData(title: "資産一覧", iconNm: "hand.thumbsup"),
                  TabData(title: "負債一覧", iconNm: "hand.thumbsdown")]
    // 画面遷移データ
    @State var isDetailPagePresented = false
    @State var selectBalModel = BalanceModel()
    // データ取得
    let viewModel = BalanceViewModel()
    var body: some View {
        NavigationStack {
            GeometryReader {
                let localSize = $0.frame(in: .local).size
                VStack(spacing: 0) {
                    Title(title: "残高一覧", message: "資産・負債の残高を一覧で表示")
//                        .padding(.bottom, 10)
                    ShrinkableTab(selectedIndex: $dispInfoIndex, titles: titles)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                    TotalCard(size: localSize)
                        .zIndex(1000)
                    BalanceList(size: localSize)
                }
            }
        }.onAppear {
            self.dispBalDataDic = allBalDataDic
        }.onChange(of: dispInfoIndex) {
            withAnimation {
                switch dispInfoIndex {
                case 0:
                    self.dispBalDataDic = allBalDataDic
                case 1:
                    self.dispBalDataDic = [0: allBalDataDic[0]!]
                case 2:
                    self.dispBalDataDic = [1: allBalDataDic[1]!]
                default:
                    self.dispBalDataDic = allBalDataDic
                }
            }
        }.onChange(of: isDetailPagePresented) {
            if !isDetailPagePresented {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        self.allBalDataDic = viewModel.getBalanceDic()
                        self.dispBalDataDic = allBalDataDic
                    }
                }
            }
        }.onChange(of: isRegistPagePresented) {
            if !isRegistPagePresented {
                withAnimation {
                    self.allBalDataDic = viewModel.getBalanceDic()
                    self.dispBalDataDic = allBalDataDic
                }
            }
        }.navigationDestination(isPresented: $isDetailPagePresented) {
            BalanceDetailPage(isPresented: $isDetailPagePresented,
                              accentColor: accentColor,
                              accentTextColor: accentTextColor,
                              balModel: selectBalModel)
        }
    }
    
    @ViewBuilder
    func TotalCard(size: CGSize) -> some View {
        let labels = ["資産合計", "負債合計", "純資産合計"]
        Card {
            HStack(spacing: 0){
                ForEach(0 ..< 3, id: \.self) { index in
                    VStack {
                        Text("¥\(balTotalDic[index]!)")
                            .font(.footnote)
                            .lineLimit(1)
                        Text(labels[index])
                            .font(.caption)
                    }.frame(width: (size.width - 80) / 3)
                    if index != 2 {
                        Bar().frame(height: 20)
                            .padding(.horizontal, 10)
                    }
                }
            }.padding(.horizontal, 10)
        }.frame(height: 70)
            .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    func BalanceInfoArea(size: CGSize, balanceModel: BalanceModel) -> some View {
        HStack(spacing: 0) {
            RoundedRectangle(cornerRadius: .infinity)
                .fill(CommonViewModel.getColorFromHex(hex: balanceModel.balColorHex))
                .frame(width: 5, height: 50)
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
                        .foregroundStyle(balanceModel.balAmount < 0 ? .red : .changeableText)
                }
            }.font(.subheadline)
            Image(systemName: "chevron.compact.right")
                .foregroundStyle(.gray)
        }.frame(height: 70)
    }
    
    @ViewBuilder
    func BalanceList(size: CGSize) -> some View {
        let allInfoDisp = dispInfoIndex == 0
        ScrollView {
            VStack {
                ForEach(dispBalDataDic.keys.sorted(), id: \.self) { key in
                    if allInfoDisp {
                        Footnote(text: key == 0 ? "資産" : "負債")
                            .frame(width: size.width - 20, alignment: .leading)
                    } else {
                        Footnote(text: key == 0 ? "資産一覧" : "負債一覧")
                            .frame(width: size.width - 20, alignment: .leading)
                    }
                    HStack {
                        if allInfoDisp {
                            Bar().padding(.trailing, 10)
                        }
                        let results = dispBalDataDic[key]
                        if !results!.isEmpty {
                            Card {
                                VStack(spacing: 0) {
                                    ForEach(results!.indices, id: \.self) { index in
                                        let balModel = results![index]
                                        BalanceInfoArea(size: size, balanceModel: balModel)
                                            .contentShape(.rect)
                                            .onTapGesture {
                                                self.selectBalModel = balModel
                                                self.isDetailPagePresented = true
                                            }
                                        if results!.count > 1 && index < results!.count - 1 {
                                            Border().padding(.horizontal, 10)
                                        }
                                    }
                                }.padding(.horizontal, 10)
                            }.frame(height: 70 * CGFloat(results!.count) + CGFloat(1 * results!.count))
                        } else {
                            VStack {
                                ResizColableImage(key == 0 ? "watoring.money" : "happy.person")
                                    .frame(width: 50, height: 50)
                                Footnote(text: key == 0 ? "資産残高は存在しません" : "負債残高は存在しません")
                            }.frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                        }
                    }.padding(.horizontal, 10)
                        .padding(.leading, allInfoDisp ? 10 : 0)
                }
            }.padding(.top, 10)
        }
    }
}

//#Preview {
//   ContentView()
//}

#Preview {
    @Previewable @State var isRegistPagePresented = false
    BalanceListPage(isRegistPagePresented: $isRegistPagePresented, accentColor: .yellow, accentTextColor: .black)
}

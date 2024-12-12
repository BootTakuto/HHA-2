//
//  BalanceListPage.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/12.
//

import SwiftUI
import RealmSwift

struct BalanceListPage: View {
    // 表示データ
    @State var balTotal = BalanceViewModel().getBalTotal()
    @State var dispInfoIndex = 0
    @State var balDataDisc = BalanceViewModel().getBalanceDic()
    var titles = [ShrinableTabTitle(title: "資産・負債一覧", iconNm: "square.stack.3d.up"),
                  ShrinableTabTitle(title: "資産一覧", iconNm: "hand.thumbsup"),
                  ShrinableTabTitle(title: "負債一覧", iconNm: "hand.thumbsdown")]
    // 画面表示制御
    @State var totalCardOffset: CGFloat = -10
    // データ取得
    let viewModel = BalanceViewModel()
    var body: some View {
        NavigationStack {
            GeometryReader {
                let localSize = $0.frame(in: .local).size
                VStack(spacing: 0) {
                    ShrinkableTab(selectedIndex: $dispInfoIndex, titles: titles)
                    TotalCard(size: localSize)
                    BalanceList(size: localSize)
//                    HStack {
//                        Text("資産・負債一覧")
//                            .font(.subheadline)
//                        Button(action: {
//                            
//                        }) {
//                            Image(systemName: "questionmark.circle")
//                        }
//                    }.fontWeight(.medium)
//                        .foregroundStyle(.changeableText)
//                        .padding(.bottom, 20)
//                    SegmentedSelector(selectedIndex: $dispInfoIndex, texts: ["すべて", "資産", "負債",])
//                        .padding(.horizontal, 50)
//                    ZStack (alignment: .top) {
//                        BalanceList(size: localSize)
//                        MoveableCard(size: localSize)
//                            .onTapGesture {
//                                withAnimation {
//                                    if totalCardOffset == -10 {
//                                        self.totalCardOffset = -localSize.width + 20
//                                    } else {
//                                        self.totalCardOffset = -10
//                                    }
//                                }
//                            }
//                    }.padding(.vertical, 20)
                    HStack {
                        
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func MoveableCard(size: CGSize) -> some View {
        Card {
            HStack(spacing: 0) {
                Text("残高合計")
                    .padding(.leading, 5)
                Spacer()
                Text("¥\(balTotal)")
                    .lineLimit(1)
                    .frame(width: size.width / 2 - 20, alignment: .trailing)
                    .foregroundStyle(balTotal < 0 ? .red : .changeableText)
                Image(systemName: "chevron.compact.right")
                    .rotationEffect(Angle(degrees: totalCardOffset == -10 ? 180 : 0))
                    .foregroundStyle(.gray)
                    .padding(.horizontal, 6)
            }
            .padding(.leading, 10)
        }.frame(height: 80)
            .offset(x: totalCardOffset)
    }
    
    @ViewBuilder
    func TotalCard(size: CGSize) -> some View {
        let labels = ["資産合計", "負債合計", "純資産合計"]
        Card {
            HStack(spacing: 0){
                ForEach(0 ..< 3, id: \.self) { index in
                    VStack {
                        Text("¥\(100000000)")
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
        }.frame(height: 60)
            .padding(.horizontal, 10)
            .padding(.vertical, 20)
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
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
        }.frame(height: 80)
    }
    
    @ViewBuilder
    func BalanceList(size: CGSize) -> some View {
        ScrollView {
            VStack {
                ForEach(balDataDisc.keys.sorted(), id: \.self) { key in
                    Footnote(text: key == 0 ? "資産" : "負債")
                        .frame(width: size.width - 20, alignment: .leading)
                    HStack {
                        Bar().padding(.trailing, 10)
                        let results = balDataDisc[key]
                        if !results!.isEmpty {
                            Card {
                                VStack(spacing: 0) {
                                    ForEach(results!.indices, id: \.self) { index in
                                        let balModel = results![index]
                                        BalanceInfoArea(size: size, balanceModel: balModel)
                                        if results!.count > 1 && index < results!.count - 1 {
                                            Border().padding(.horizontal, 10)
                                        }
                                    }
                                }.padding(.horizontal, 10)
                            }.frame(height: 80 * CGFloat(results!.count) + CGFloat(1 * results!.count))
                        } else {
                            Footnote(text: key == 0 ? "資産は存在しません" : "負債は存在しません")
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                        }
                    }.padding(.horizontal, 10)
                        .padding(.leading, 10)
                }
            }
        }
    }
    
//    @ViewBuilder
//    func BalanceList(size: CGSize) -> some View {
//        ScrollView {
//            ForEach(0 ..< 2, id: \.self) { flg in
//                Footnote(text: flg == 0 ? "資産" : "負債")
//                    .frame(width: size.width - 20, alignment: .leading)
//                HStack {
//                    Bar().padding(.trailing, 10)
//                    if balanceList.isEmpty {
//                        Footnote(text: "")
//                            .foregroundStyle(.gray)
//                            .padding(.top, 150)
//                    } else {
//                        Card {
//                            VStack(spacing: 0) {
//                                ForEach(balanceList.indices, id: \.self) { index in
//                                    let balModel = balanceList[index]
//                                    BalanceInfoArea(size: size, balanceModel: balModel)
//                                        .frame(height: 70)
//                                        .padding(.horizontal, 15)
//                                    if (balanceList.count > 1 && index < balanceList.count - 1) {
//                                        Border()
//                                            .padding(.horizontal, 10)
//                                            .padding(.vertical, 5)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }.frame(height: 80 * CGFloat(balanceList.count) + CGFloat(balanceList.count - 1))
//                .padding(.horizontal, 10)
//                .padding(.top, totalCardOffset == -10 ? 100 : 10)
//        }.scrollIndicators(.hidden)
//    }
}

//struct BalanceListPage: View {
//    var accentColor: Color = CommonViewModel.getAccentColor()
//    var accentTextColor: Color = CommonViewModel.getTextColor()
//    @Binding var isTotalShow: Bool
////    @State var balanceList = BalanceViewModel().getBalnaceResults()
//    @ObservedResults(BalanceModel.self) var balanceList
//    @State var balTotal = BalanceViewModel().getBalTotal()
//    // 残高入力関連
//    @State var isSheetShow = false
//    @State var inputBalNm = ""
//    @State var selectBalColorHex = "FFFFFF"
//    // 画面表示設定
//    @State var hiddenOffset: CGFloat = -50
//    // 遷移情報
//    @State var isPresentedBalDetail = false
//    @State var balModel = BalanceModel()
//    // ビューモデル
//    let viewModel = BalanceViewModel()
//    var body: some View {
//        NavigationStack {
//            GeometryReader {
//                let size = $0.size
//                VStack(spacing: 0) {
//                    BalTotalHeader(size: size)
//                        .zIndex(1000)
//                    BalTotalList(size: size)
//                        .offset(y: isTotalShow ? 0 : hiddenOffset)
//                        .frame(height: size.height)
//                }.floatingSheet(isPresented: $isSheetShow) {
//                    RegistBalancePopUp(size: size)
//                        .presentationDetents([.fraction(0.999)])
//                        .padding(.horizontal, 20)
//                }
//            }
//        }.navigationDestination(isPresented: $isPresentedBalDetail) {
//            BalanceDetailPage(isPresented: $isPresentedBalDetail,
//                              accentColor: accentColor,
//                              accentTextColor: accentTextColor,
//                              balModel: balModel)
//        }
//    }
//    
//    @ViewBuilder
//    func BalTotalHeader(size: CGSize) -> some View {
//        InnerHeader(isShow: $isTotalShow, hiddenOffset: hiddenOffset, height: 80) {
//            HStack(spacing: 0) {
//                Text("合計")
//                    .frame(width: size.width / 2 - 10, alignment: .leading)
//                    .padding(.leading, 10)
//                Text("¥\(balTotal)")
//                    .lineLimit(1)
//                    .minimumScaleFactor(0.5)
//                    .frame(width: size.width / 2 - 50, alignment: .trailing)
//                    .foregroundStyle(balTotal < 0 ? .red : .changeableText)
//                CircleButton(imageNm: "plus") {
//                    withAnimation {
//                        self.isSheetShow.toggle()
//                    }
//                }.frame(width: 25, height: 25)
//                    .padding(.leading, 5)
//            }.font(.title3)
//                .offset(y: 5)
//        }
//    }
//    
//    @ViewBuilder
//    func BalDetaiCard(size: CGSize, balanceModel: BalanceModel) -> some View {
//        Card {
//            HStack(spacing: 0) {
//                RoundedRectangle(cornerRadius: .infinity)
//                    .fill(CommonViewModel.getColorFromHex(hex: balanceModel.balColorHex))
//                    .frame(width: 5, height: 60)
//                VStack {
//                    HStack(spacing: 0) {
//                        Text(balanceModel.balName)
//                            .padding(.leading, 10)
//                            .lineLimit(1)
//                        Spacer()
//                    }
//                    HStack(spacing: 0) {
//                        Spacer()
//                        Text("¥\(balanceModel.balAmount)")
//                            .padding(.trailing, 10)
//                            .lineLimit(1)
//                            .foregroundStyle(balanceModel.balAmount < 0 ? .red : .changeableText)
//                    }
//                }.font(.subheadline)
//                Image(systemName: "chevron.right")
//                    .foregroundStyle(.gray)
//            }.padding(.horizontal, 10)
//        }.frame(height: 80)
//            .onTapGesture {
//                self.isPresentedBalDetail = true
//                self.balModel = balanceModel
//            }
//    }
//    
//    @ViewBuilder
//    func BalTotalList(size: CGSize) -> some View {
//        if !balanceList.isEmpty {
//            ScrollView {
//                VStack(spacing: 0) {
//                    ForEach(balanceList, id: \.self) { balModel in
//                        BalDetaiCard(size: size, balanceModel: balModel)
//                            .padding(.bottom, 15)
//                            .padding(.horizontal, 15)
//                    }
//                }.padding(.top, 20)
//                    .padding(.bottom, isTotalShow ? 140 : 90)
//            }.scrollIndicators(.hidden)
//        } else {
//            VStack {
//                Text("登録されている残高がありません。")
//                    .foregroundStyle(.gray)
//                RoundedButton(radius: 10, text: "残高を登録する") {
//                    self.isSheetShow.toggle()
//                }.frame(width: 120, height: 30)
//            }
//        }
//    }
//    
//    @ViewBuilder
//    func RegistBalancePopUp(size: CGSize) -> some View {
//        Card {
//            VStack(spacing: 0) {
//                Text("残高情報の登録")
//                    .foregroundStyle(.changeableText)
//                    .padding(.bottom, 5)
//                    .padding(.top, 10)
//                Footnote(text: "残高")
//                    .frame(width: size.width - 60, alignment: .leading)
//                    .padding(.bottom, 5)
//                InputText(placeHolder: "20文字以内", text: $inputBalNm, isDispShadow: false)
//                    .padding(.bottom, 10)
//                HStack {
//                    Footnote(text: "タグ")
//                    Spacer()
//                    Circle()
//                        .fill(CommonViewModel.getColorFromHex(hex: selectBalColorHex))
//                        .frame(width: 25, height: 25)
//                        .shadow(color: .changeableShadow, radius: 3)
//                        .padding(.trailing, 5)
//                }.padding(.bottom, 5)
//                ScrollView {
//                    VStack {
//                        Palette(hex: $selectBalColorHex)
//                    }.frame(height: 320)
//                }.clipShape(RoundedRectangle(cornerRadius: 10))
//                    .frame(height: 150)
//                    .scrollIndicators(.hidden)
//                    .padding(.bottom, 10)
//                RegistButton(text: "登録", isDisabled: inputBalNm.isEmpty) {
//                    let balanceModel = BalanceModel()
//                    balanceModel.balKey = UUID().uuidString
//                    balanceModel.balName = inputBalNm
//                    balanceModel.balColorHex = selectBalColorHex
//                    viewModel.reigstBalance(balanceModel: balanceModel)
//                    self.isSheetShow.toggle()
//                }.frame(height: 40)
//                    .padding(.bottom, 5)
//                CancelButton(text: "閉じる") {
//                    self.isSheetShow.toggle()
//                }.frame(height: 40)
//            }.padding(.horizontal, 10)
//                .frame(height: 400, alignment: .top)
//        }.frame(height: 400)
//    }
//}

#Preview {
   ContentView()
}

//#Preview {
//    BalanceListPage(accentColor: .orange)
//}

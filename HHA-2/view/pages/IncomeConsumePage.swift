//
//  DepositWithdrawPage.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/12.
//

import SwiftUI

struct IncomeConsumePage: View {
    @Binding var isTotalShow: Bool
    @State var hiddenOffset: CGFloat = -190
    @State var selectDate = Date()
    
    /* 収入・支出表示データ */
    @State var incTotal = IncomeConsumeViewModel().getIncOrConsMonthlyTotal(selectedDate: Date(), incConsFlg: 0)      // 月間収入合計金額
    @State var consTotal = IncomeConsumeViewModel().getIncOrConsMonthlyTotal(selectedDate: Date(), incConsFlg: 1)     // 月間支出合計金額
    @State var incConsDic = IncomeConsumeViewModel().getIncConsDic(selectedDate: Date())                              // リスト表示用辞書
    @State var incPieDataArray = IncomeConsumeViewModel().getIncConsPieDataArray(incConsFlg: 0, selectedDate: Date()) // 収入円チャート用データ
    @State var consPieDataArray = IncomeConsumeViewModel().getIncConsPieDataArray(incConsFlg: 1, selectedDate: Date())// 支出円チャート用データ
    let viewModel = IncomeConsumeViewModel()
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                IncConsTotalHeader(size: geometry.size)
                    .zIndex(1000)
                IncConsList(size: geometry.size)
                    .offset(y: isTotalShow ? 0 : hiddenOffset)
                    .frame(height: geometry.size.height)
            }
        }.onChange(of: selectDate) {
            // 収入・支出合計金額を取得
            self.incTotal = viewModel.getIncOrConsMonthlyTotal(selectedDate: selectDate, incConsFlg: 0)
            self.consTotal = viewModel.getIncOrConsMonthlyTotal(selectedDate: selectDate, incConsFlg: 1)
            // 収入・支出表示用辞書の取得
            self.incConsDic = viewModel.getIncConsDic(selectedDate: selectDate)
            // 収入・支出チャートの作成
            self.incPieDataArray = viewModel.getIncConsPieDataArray(incConsFlg: 0, selectedDate: selectDate)
            self.consPieDataArray = viewModel.getIncConsPieDataArray(incConsFlg: 1, selectedDate: selectDate)
        }
    }
    
    @ViewBuilder
    func IncConsTotalHeader(size: CGSize) -> some View {
        InnerHeader(isShow: $isTotalShow, hiddenOffset: hiddenOffset, height: CGFloat(220)) {
            VStack(spacing: 0) {
                YearMonthSelector(targetDate: $selectDate)
                    .padding(.vertical, 5)
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(0 ..< 3, id: \.self) { index in
                            HStack {
                                switch index {
                                case 0:
                                    CompareChart(target: incTotal, comparison: consTotal, width: 20)
                                case 1:
                                    PieChartIncCons(size: size, chartTitle: "収入構成", incConsFlg: 0)
                                case 2:
                                    PieChartIncCons(size: size, chartTitle: "支出構成", incConsFlg: 1)
                                default:
                                    CompareChart(target: incTotal, comparison: consTotal, width: 20)
                                }
                            }.padding(.horizontal, 20)
                                .frame(height: 140)
                            .containerRelativeFrame([.horizontal])
                        }
                    }.scrollTargetLayout()
                }.scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                    .frame(height: 150)
            }
        }
    }
    
    @ViewBuilder
    func PieChartIncCons(size: CGSize, chartTitle: String, incConsFlg: Int) -> some View {
        let pieDataArray = incConsFlg == 0 ? incPieDataArray : consPieDataArray
        HStack(spacing: 0) {
            PieChart(chartTitle: chartTitle,
                     dataArray: pieDataArray,
                     emptyColor: incConsFlg == 0 ? .blue.opacity(0.25) : .red.opacity(0.25))
                .frame(width: (size.width - 20) / 2)
            ScrollView {
                VStack(spacing: 5) {
                    ForEach(pieDataArray.indices, id: \.self) { index in
                        let data = pieDataArray[index]
                        HStack(alignment: .center) {
                            Circle().fill(data.bgColor).frame(width: 15)
                            HStack(spacing: 0) {
                                Text(data.valNm)
                                    .font(.caption2)
                                    .frame(width: 60, alignment: .leading)
                                    .lineLimit(1)
                                Text("\(data.ratio)%")
                                    .font(.caption2)
                                    .frame(width: 60, alignment: .leading)
                                    .lineLimit(1)
                            }
                        }
                    }
                }
            }.frame(width: (size.width - 20) / 2)
        }
    }
    
    @ViewBuilder
    func IncConsStack(size: CGSize, incConsData: IncConsDataBySec) -> some View {
        let incConsFlg = incConsData.incConsFlg
        let amtTotal = incConsData.amtTotal
        let secModel = incConsData.secModel
        let iconRectColor = CommonViewModel.getColorFromHex(hex: secModel.iconColorHex)
        let iconTextColor = CommonViewModel.getTextColorFromHex(hex: secModel.iconColorHex)
        HStack {
            RoundedIcon(image: secModel.iconImageNm,
                        rectColor: iconRectColor,
                        iconColor: iconTextColor)
            Footnote(text: secModel.secNm, color: .changeableText)
            Spacer()
            Text("\(amtTotal)")
                .foregroundStyle(incConsFlg == 0 ? .blue : incConsFlg == 1 ? .red : .changeableText)
                .frame(width: size.width / 2, alignment: .trailing)
        }.padding(.horizontal, 10)
    }
    
    @ViewBuilder
    func IncConsList(size: CGSize) -> some View {
        ScrollView {
            VStack {
                ForEach(incConsDic.keys.sorted(), id: \.self) { key in
                    let dataArray = incConsDic[key]?.sorted(by: {$0.amtTotal > $1.amtTotal}) ?? []
                    VStack {
                        Footnote(text: key == 0 ? "収入" : "支出")
                            .frame(width: size.width - 20, alignment: .leading)
                        HStack {
                            Bar()
                                .padding(.trailing, 10)
                            Card {
                                VStack {
                                    ForEach(dataArray.indices, id: \.self) {index in
                                        let data = dataArray[index]
                                        IncConsStack(size: size, incConsData: data)
                                        if (dataArray.count > 1 && index % 2 == 0) {
                                            Border()
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 5)
                                        }
                                    }
                                }
                            }.frame(height: 60 * CGFloat(dataArray.count))
                        }.padding(.horizontal, 10)
                            .padding(.leading, 10)
                    }.padding(.top, 10)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

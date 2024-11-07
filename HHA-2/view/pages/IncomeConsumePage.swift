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
    var body: some View {
        GeometryReader { geometry in
            VStack {
                DepoDrawsTotalHeader(size: geometry.size)
                DepoDrawsList()
                    .offset(y: isTotalShow ? 0 : hiddenOffset)
                    .frame(height: geometry.size.height)
            }
        }
    }
    
    @ViewBuilder
    func DepoDrawsTotalHeader(size: CGSize) -> some View {
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
                                    CompareChart(target: 200000000000, comparison: 300000000000, width: 20)
                                case 1:
                                    PieChartDepoDraw(size: size, chartTitle: "入金項目")
                                case 2:
                                    PieChartDepoDraw(size: size, chartTitle: "出金項目")
                                default:
                                    CompareChart(target: 200000000000, comparison: 300000000000, width: 20)
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
    func PieChartDepoDraw(size: CGSize, chartTitle: String) -> some View {
        HStack(spacing: 0) {
            PieChart(chartTitle: chartTitle)
                .frame(width: (size.width - 20) / 2)
            ScrollView {
                VStack(spacing: 5) {
                    ForEach(0 ..< 1, id: \.self) { index in
                        HStack(alignment: .center) {
                            Circle().fill(.blue).frame(width: 10)
                            Text("テスト(\(0.2)%)")
                                .font(.caption2)
                        }
                    }
                }
            }.frame(width: (size.width - 20) / 2)
        }
    }
    
    @ViewBuilder
    func DepoDrawsList() -> some View {
        
    }
}

#Preview {
    ContentView()
}

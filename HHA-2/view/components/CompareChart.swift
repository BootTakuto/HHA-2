//
//  Charts.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/15.
//

import SwiftUI
import Charts

struct CompareChart: View {
    var target: Int
    var comparison: Int
    var width: CGFloat = 30
    let commonVm = CommonViewModel()
    var body: some View {
        let gap = target - comparison
        Chart {
//            BarMark(
//                x: .value("amount", target),
//                y: .value("category", "入金額計"),
//                width: .fixed(width)
//            ).foregroundStyle(.blue)
//            .annotation(position: .trailing, spacing: 5) {
//                Text("¥\(target)")
//                    .font(.system(size: 10))
//                    .foregroundStyle(target > 0 ? .blue : .red)
//            }
//            BarMark(
//                x: .value("amount", comparison),
//                y: .value("category", "出金額計"),
//                width: .fixed(width)
//            ).foregroundStyle(.red)
//            .annotation(position: .trailing, spacing: 5) {
//                Text("¥\(comparison)")
//                    .font(.system(size: 10))
//                    .foregroundStyle(comparison > 0 ? .red : .blue)
//            }
//            BarMark(
//                x: .value("amount", gap),
//                y: .value("category", "入出金差額"),
//                width: .fixed(width)
//            )
            BarMark(
                x: .value("category", "入金額計"),
                y: .value("amount", target),
                width: .fixed(width)
            ).foregroundStyle(.blue)
                .shadow(color: .changeableShadow, radius: 1, x: 1, y: 1)
                .annotation(position: .top, alignment: .center, spacing: 5) {
                Text("¥\(target)")
                    .font(.system(size: 10))
                    .foregroundStyle(target > 0 ? .blue : .red)
            }
            BarMark(
                x: .value("category", "出金額計"),
                y: .value("amount", comparison),
                width: .fixed(width)
            ).foregroundStyle(.red)
                .shadow(color: .changeableShadow, radius: 1, x: 1, y: 1)
            .annotation(position: .top, alignment: .center, spacing: 5) {
                Text("¥\(comparison)")
                    .font(.system(size: 10))
                    .foregroundStyle(comparison > 0 ? .red : .blue)
            }
            BarMark(
                x: .value("category", "入出金差額"),
                y: .value("amount", gap),
                width: .fixed(width)
            ).foregroundStyle(gap > 0 ? .blue : .red)
                .shadow(color: .changeableShadow, radius: 1, x: 1, y: 1)
            .annotation(position: .top, alignment: .center, spacing: 5) {
                Text("¥\(gap)")
                    .font(.system(size: 10))
                    .foregroundStyle(gap > 0 ? .blue : .red)
            }
        }.chartYAxis {
            AxisMarks{
                AxisGridLine()
            }
        }.chartXAxis {
            AxisMarks {
                AxisValueLabel()
                    .font(.system(size: 10))
//                AxisGridLine()
            }
            
        }
    }
}

#Preview {
    CompareChart(target: 1000, comparison: 1100)
}

//
//  PieChart.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/15.
//

import SwiftUI
import Charts

struct PieChart: View {
    var chartTitle: String
    var data = [0, 1, 2, 3, 4, 5]
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Text(chartTitle)
                        .font(.caption2)
                }
                Chart(data, id: \.self) { index in
                    SectorMark(
                        angle: .value("value", data[index]),
                        innerRadius: .ratio(0.6),
                        angularInset: 0.5
                    )
                }
            }
        }
    }
}

#Preview {
    PieChart(chartTitle: "テスト")
}

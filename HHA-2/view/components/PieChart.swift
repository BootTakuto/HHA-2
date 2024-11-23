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
    @State var dataArray: [PieData]
    @State var sortedArray = [PieData]()
    var emptyColor = Color.blue.opacity(0.25)
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Text(chartTitle)
                        .font(.caption2)
                }
                if dataArray.isEmpty {
                    Chart {
                        SectorMark(
                            angle: .value("value", 1),
                            innerRadius: .ratio(0.6),
                            angularInset: 0.5
                        ).foregroundStyle(emptyColor)
                    }
                } else {
                    Chart(sortedArray.indices, id: \.self) { index in
                        let data = sortedArray[index]
                        SectorMark(
                            angle: .value("value", data.value),
                            innerRadius: .ratio(0.6),
                            angularInset: 0.5
                        ).foregroundStyle(data.bgColor)
                    }
                }
            }
        }.onAppear {
            print(dataArray)
            self.sortedArray = dataArray.sorted {$0.value < $1.value}
        }
    }
}

#Preview {
    @Previewable @State var data = [
        PieData(id: "0", valNm: "a", value: 1, ratio: 1, bgColor: .yellow),
        PieData(id: "1", valNm: "b", value: 5, ratio: 5, bgColor: .orange),
        PieData(id: "2", valNm: "c", value: 2, ratio: 2, bgColor: .red),
        PieData(id: "3", valNm: "d", value: 3, ratio: 3, bgColor: .pink),
        PieData(id: "4", valNm: "e", value: 4, ratio: 4, bgColor: .purple)
    ]
    PieChart(chartTitle: "テスト", dataArray: data)
}

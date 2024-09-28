//
//  CalendarPage.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/12.
//

import SwiftUI

struct CalendarPage: View {
    @Binding var isCalendarShow: Bool
    @State var hiddenOffset: CGFloat = -270
    @State var selectDate = Date()
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                CalendarHeader(size: geometry.size)
                    .zIndex(1000)
                DepoDrawListByDay(size: geometry.size)
                    .offset(y: isCalendarShow ? 0 : hiddenOffset)
                    .frame(height: geometry.size.height)
            }
        }
    }
    
    @ViewBuilder
    func CalendarHeader(size: CGSize) -> some View {
        let dayLabels = ["月", "火", "水", "木", "金", "土", "日"]
        InnerHeader(isShow: $isCalendarShow, hiddenOffset: hiddenOffset, height: CGFloat(300)) {
            VStack(spacing: 0) {
                YearMonthSelector(targetDate: $selectDate)
                    .padding(.vertical, 5)
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(0 ..< 7, id: \.self) { index in
                            Text(dayLabels[index])
                                .font(.system(size: 10))
                                .frame(width: size.width / 7 - 2)
                        }
                    }.frame(height: 10)
                    ForEach(0 ..< 6, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0 ..< 7, id: \.self) { col in
                                let index = col + (row * 7)
                                Rectangle()
                                    .fill(.clear)
                                    .frame(width: size.width / 7 - 2, height: 230 / 6)
                                    .overlay {
                                        VStack {
                                            Text("\(index)")
                                            Group {
                                                if index == 5 || index == 15 || index == 16 || index == 38 {
                                                    Text("¥\(150000)")
                                                        .lineLimit(1)
                                                    Text("¥\(1000)")
                                                        .lineLimit(1)
                                                } else {
                                                    Spacer()
                                                }
                                            }.frame(maxWidth: size.width / 7 - 2, alignment: .leading)
                                        }.font(.system(size: 10))
                                    }
                            }
                        }
                    }
                }.frame(height: 240)
                    .padding(.horizontal, 7)
            }
        }
    }
    
    @ViewBuilder
    func DepoDrawTotalCard(size: CGSize) -> some View {
        let depo = 450000
        let draw = 40000
        let total = depo - draw
        ZStack {
            Card()
            HStack(spacing: 0) {
                VStack {
                    Text("¥\(depo)")
                        .font(.caption)
                    Text("入金")
                        .font(.caption2)
                }.frame(width: size.width / 3 - 20)
                Border()
                    .frame(height: 20)
                    .padding(.horizontal, 5)
                VStack {
                    Text("¥\(draw)")
                        .font(.caption)
                    Text("出金")
                        .font(.caption2)
                }.frame(width: size.width / 3 - 20)
                Border()
                    .frame(height: 20)
                    .padding(.horizontal, 5)
                VStack {
                    Text("¥\(total)")
                        .font(.caption)
                    Text("合計")
                        .font(.caption2)
                }.frame(width: size.width / 3 - 20)
            }
        }.frame(height: 60)
            .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    func DepoDrawListByDay(size: CGSize) -> some View {
        ScrollView {
            VStack {
                DepoDrawTotalCard(size: size)
            }.padding(.top, 10)
        }
    }
}

#Preview {
    ContentView()
}

//#Preview {
//    CalendarPage()
//}

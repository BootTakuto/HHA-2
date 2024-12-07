//
//  CalendarPage.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/12.
//

import SwiftUI

struct CalendarPage: View {
    @Binding var isCalendarShow: Bool
    var accentColor: Color
    var accentTextColor: Color
    @State var hiddenOffset: CGFloat = -290
    @State var selectDate = Date()
    @State var caledarDataArray = CalendarViewModel().getCalendarDays(selectedDate: Date())
    @State var currnetDate = CalendarViewModel().getFormatDate(format: "yyyyMMdd", date: Date())
    @State var incTotal = CalendarViewModel().getIncOrConsMonthlyTotal(incConsFlg: 0, selectedDate: Date())
    @State var consTotal = CalendarViewModel().getIncOrConsMonthlyTotal(incConsFlg: 1, selectedDate: Date())
    @State var incConsDic = CalendarViewModel().getIncConsDicByDay(selectedDate: Date())
    let viewModel = CalendarViewModel()
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                CalendarHeader(size: geometry.size)
                    .zIndex(1000)
                IncConsListByDay(size: geometry.size)
                    .offset(y: isCalendarShow ? 0 : hiddenOffset)
                    .frame(height: geometry.size.height)
            }
        }.onChange(of: selectDate) {
            withAnimation {
                // カレンダー日付配列
                caledarDataArray = viewModel.getCalendarDays(selectedDate: selectDate)
                // 収入・支出合計金額
                incTotal = viewModel.getIncOrConsMonthlyTotal(incConsFlg: 0, selectedDate: selectDate)
                consTotal = viewModel.getIncOrConsMonthlyTotal(incConsFlg: 1, selectedDate: selectDate)
                // 収入・支出データ
                incConsDic = viewModel.getIncConsDicByDay(selectedDate: selectDate)
            }
        }
    }
    
    @ViewBuilder
    func CalendarHeader(size: CGSize) -> some View {
        let dayLabels = ["月", "火", "水", "木", "金", "土", "日"]
        InnerHeader(isShow: $isCalendarShow, hiddenOffset: hiddenOffset, height: CGFloat(320)) {
            VStack(spacing: 0) {
                YearMonthSelector(targetDate: $selectDate)
                    .padding(.vertical, 5)
                VStack(spacing: 3) {
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
                                let calendarData = caledarDataArray[index]
                                let isCurrent = currnetDate == calendarData.yyyyMMdd
                                Rectangle()
                                    .fill(.clear)
                                    .frame(width: size.width / 7 - 2, height: 230 / 6)
                                    .overlay {
                                        VStack {
                                            Text(calendarData.day)
                                                .foregroundStyle(calendarData.isOtherMonth ? isCurrent ? .white : .gray :
                                                                    isCurrent  ? accentTextColor : .changeableText)
                                                .background {
                                                    Circle()
                                                        .fill(isCurrent ? calendarData.isOtherMonth ? .gray : accentColor : .clear)
                                                        .frame(width: 15, height: 15)
                                                }
                                            Group {
                                                Text(calendarData.incConsExsistFlg == 0 || calendarData.incConsExsistFlg == 2 ?
                                                     "¥\(calendarData.dayIncTotal)" : "")
                                                    .lineLimit(1)
                                                    .foregroundStyle(.blue)
                                                Text(calendarData.incConsExsistFlg == 1 || calendarData.incConsExsistFlg == 2 ? "¥\(calendarData.dayConsTotal)" : "")
                                                    .lineLimit(1)
                                                    .foregroundStyle(.red)
                                            }.frame(width: size.width / 7 - 2)
                                        }.font(.system(size: 10))
                                    }
                            }
                        }
                    }
                }.frame(height: 260)
                    .padding(.horizontal, 7)
            }
        }
    }
    
    @ViewBuilder
    func IncConsTotalCard(size: CGSize) -> some View {
        let total = incTotal - consTotal
        Card() {
            HStack(spacing: 0) {
                VStack {
                    Text("¥\(incTotal)")
                        .font(.caption)
                        .foregroundStyle(.blue)
                    Text("収入")
                        .font(.caption2)
                }.frame(width: size.width / 3 - 20)
                Bar()
                    .frame(height: 20)
                    .padding(.horizontal, 5)
                VStack {
                    Text("¥\(consTotal)")
                        .font(.caption)
                        .foregroundStyle(.red)
                    Text("支出")
                        .font(.caption2)
                }.frame(width: size.width / 3 - 20)
                Bar()
                    .frame(height: 20)
                    .padding(.horizontal, 5)
                VStack {
                    Text("¥\(total)")
                        .font(.caption)
                        .foregroundStyle(total <= 0 ? .red : .blue)
                    Text("収支合計")
                        .font(.caption2)
                }.frame(width: size.width / 3 - 20)
            }
        }.frame(height: 60)
            .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    func IncConsStack(size: CGSize, incConsData: IncConsDataByDay) -> some View {
        let incConsFlg = incConsData.incConsFlg
        let secModel = incConsData.secModel
        let catgModel = incConsData.catgModel
        let amount = incConsData.amount
        let rectColor = CommonViewModel.getColorFromHex(hex: secModel.iconColorHex)
        let iconColor = CommonViewModel.getTextColorFromHex(hex: secModel.iconColorHex)
        HStack {
            RoundedIcon(radius: 6,
                        image: secModel.iconImageNm,
                        text: secModel.secNm,
                        rectColor: rectColor,
                        iconColor: iconColor)
            Footnote(text: catgModel.catgNm, color: .changeableText)
            Spacer()
            Text("\(amount)")
                .foregroundStyle(incConsFlg == 0 ? .blue : incConsFlg == 1 ? .red : .changeableText)
                .frame(width: size.width / 2, alignment: .trailing)
        }.padding(.horizontal, 10)
    }
    
    @ViewBuilder
    func IncConsListByDay(size: CGSize) -> some View {
        ScrollView {
            VStack() {
                IncConsTotalCard(size: size)
                    .padding(.top, 10)
                if incConsDic.isEmpty {
                    Footnote(text: "当月の収入・支出情報はありません。")
                        .padding(.top, 50)
                } else {
                    ForEach(Array(incConsDic.keys).sorted(by: >), id: \.self) { date in
                        let dateStr = viewModel.getFormatDate(format: "yyyy年M月d日", date: date)
                        let incConsDataArray = incConsDic[date] ?? []
                        let arrayCount = incConsDataArray.count
                        let cardHeigt: CGFloat = 50 * CGFloat(arrayCount) + CGFloat(arrayCount - 1) // 基本サイズ50 * データ数 +
                        Footnote(text: dateStr)
                            .frame(width: size.width - 20, alignment: .leading)
                            .padding(.vertical, 5)
                        HStack {
                            Bar()
                                .padding(.trailing, 10)
                            Card {
                                VStack(spacing: 0) {
                                    ForEach(incConsDataArray.indices, id: \.self) { index in
                                        let data = incConsDataArray[index]
                                        IncConsStack(size: size, incConsData: data)
                                            .frame(height: 40)
                                        if (incConsDataArray.count > 1 && index < incConsDataArray.count - 1) {
                                            Border()
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 5)
                                        }
                                    }
                                }
                            }.frame(height: cardHeigt)
                        }.padding(.horizontal, 10)
                            .padding(.leading, 10)
                    }
                }
            }.padding(.top, 10)
                .padding(.bottom, isCalendarShow ? 320 : 40)
        }.scrollIndicators(.hidden)
    }
}

#Preview {
    ContentView()
}

//#Preview {
//    CalendarPage()
//}

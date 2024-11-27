//
//  CalendarViewModel.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/11/24.
//

import Foundation
import SwiftUI
import RealmSwift

class CalendarViewModel: CommonViewModel {
    // 西暦を指定
    let calendar = Calendar.current
    
    let dateFromatter = DateFormatter()
    
    /*
     現在の日付を取得する
     -param selectDate 選択日付
     -return カレンダーに表示する日付を取得
     */
    func getCalendarDays(selectedDate: Date) -> [CalendarData] {
        // 返却用配列
        var dayArray = [CalendarData]()
        // 月初（その月の1日）
        let dateComponent = calendar.dateComponents([.year, .month], from: selectedDate)
        let firstDay = calendar.date(from: dateComponent)!
        // 月初の曜日を取得する（1が日曜~7が土曜）
        let weekDayIndex = calendar.dateComponents([.weekday], from: firstDay).weekday!
        var startDay: Date
        // カレンダーの最初の日付を取得
        if weekDayIndex == 1 {
            startDay = calendar.date(byAdding: .day, value: -6, to: firstDay)!
        } else if weekDayIndex == 2 {
            startDay = firstDay
        } else {
            startDay = calendar.date(byAdding: .day, value: -(weekDayIndex - 2), to: firstDay)!
        }
        // 別の月か否か判定するため月を取得
        let currentMonth = calendar.component(.month, from: selectedDate)
        
        // カレンダー表（横7×縦6)に表示する日付を作成
        for addValue in 0 ..< 42 {
            let date = addValue == 0 ? startDay : calendar.date(byAdding: .day, value: addValue, to: startDay)!
            let targetMonth = calendar.component(.month, from: date)
            let yyyyMMdd = getFormatDate(format: "yyyyMMdd", date: date)
            
            // 収入レコードを取得
            let incResults = getIncConsResultsByDay(incConsFlg: 0, yyyyMMdd: yyyyMMdd)
            let consResults = getIncConsResultsByDay(incConsFlg: 1, yyyyMMdd: yyyyMMdd)
            
            // 収入・支出の登録状況（0: 収入のみ、1: 支出のみ、2: どちらもある、3: どちらもない）
            var exsistFlg = 3
            var incTotal = 0
            var consTotal = 0
            if !incResults.isEmpty && !consResults.isEmpty {
                exsistFlg = 2
                incTotal = incResults.sum(of: \.incConsAmt)
                consTotal = consResults.sum(of: \.incConsAmt)
            } else if incResults.isEmpty && !consResults.isEmpty {
                exsistFlg = 1
                consTotal = consResults.sum(of: \.incConsAmt)
            } else if !incResults.isEmpty && consResults.isEmpty {
                exsistFlg = 0
                incTotal = incResults.sum(of: \.incConsAmt)
            }
            
            // カレンダー情報データの作成
            let calendarData = CalendarData(date: date,
                                            day: getFormatDate(format: "d", date: date),
                                            yyyyMMdd: yyyyMMdd,
                                            isOtherMonth: currentMonth == targetMonth,
                                            incConsExsistFlg: exsistFlg,
                                            dayIncTotal: incTotal,
                                            dayConsTotal: consTotal)
            dayArray.append(calendarData)
        }
        return dayArray
    }
    
    /*
     日毎の収入・支出レコードを取得
     -param yyyyMMdd 年月日
     -return 日毎の収入・支出レコード
     */
    func getIncConsResultsByDay(incConsFlg: Int, yyyyMMdd: String) -> Results<IncConsModel> {
        return realm.objects(IncConsModel.self).where({$0.incConsFlg == incConsFlg && $0.incConsDate == yyyyMMdd})
    }
    
    /*
     文字列から日付を算出する
     -param dateStr 文字列
     -return 日付
     */
    func getStringToDate(dateStr: String) -> Date {
        dateFromatter.calendar = Calendar(identifier: .gregorian)
        dateFromatter.dateFormat = dateFromat
        return dateFromatter.date(from: dateStr) ?? Date()
    }
    
    /*
     収入または支出合計金額を取得（月間）
     -param incConsFlg 収入・支出フラグ
     -param selectedDate 選択日付
     -return 収入または支出合計金額
     */
    func getIncOrConsMonthlyTotal(incConsFlg: Int, selectedDate: Date) -> Int {
        let results = getIncConsListByMonth(selectedDate: selectedDate)
        let incConsResults = results.where({$0.incConsFlg == incConsFlg})
        return incConsResults.sum(of: \.incConsAmt)
    }
    
    /*
     日毎に収入・支出レコード辞書を取得し、リスト表示
     -param selectedDate 選択日付
     -return 日毎収入・支出レコード辞書
     */
    func getIncConsDicByDay(selectedDate: Date) -> [String: [IncConsDataByDay]] {
        var dic = [String: [IncConsDataByDay]]()
        let results = getIncConsListByMonth(selectedDate: selectedDate)
        results.sorted(by: {$0.incConsDate < $1.incConsDate}).forEach { obj in
            let date = getStringToDate(dateStr: obj.incConsDate)
            let dateStr = getFormatDate(format: "yyyy年M月d日", date: date)
            // 連携残高の配列
            var linkBalArray = [IncConsLinkBalModel]()
            if !linkBalArray.isEmpty {
                obj.linkBalList.forEach{ balObj in
                    linkBalArray.append(balObj)
                }
            }
            // 日毎の収入・支出情報を作成
            let incConsDataByDay = IncConsDataByDay(incConsKey: obj.incConsKey,
                                                    incConsFlg: obj.incConsFlg,
                                                    date: date,
                                                    amount: obj.incConsAmt,
                                                    secModel: realm.object(ofType: IncConsSecionModel.self, forPrimaryKey: obj.incConsSecKey)!,
                                                    catgModel: realm.object(ofType: IncConsCategoryModel.self, forPrimaryKey: obj.incConsCatgKey)!,
                                                    linkBalArray: linkBalArray)
            if dic[dateStr] == nil {
                dic[dateStr] = [incConsDataByDay]
            } else {
                dic[dateStr]!.append(incConsDataByDay)
            }
        }
        return dic
    }
    
}

struct CalendarData {
    // 年月日
    var date: Date
    // 日
    var day: String
    // 年月日
    var yyyyMMdd: String
    // 選択月とことなる月か否か
    var isOtherMonth: Bool
    // 収支登録があるかないか（0: 収入のみ、1: 支出のみ、2: どちらもある、3: どちらもない）
    var incConsExsistFlg: Int
    // 収入合計金額を取得
    var dayIncTotal: Int
    // 支出合計金額を取得
    var dayConsTotal: Int
    // イニシャライザ
    init(date: Date,
         day: String,
         yyyyMMdd: String,
         isOtherMonth: Bool,
         incConsExsistFlg: Int,
         dayIncTotal: Int,
         dayConsTotal: Int) {
        self.date = date
        self.day = day
        self.yyyyMMdd = yyyyMMdd
        self.isOtherMonth = isOtherMonth
        self.incConsExsistFlg = incConsExsistFlg
        self.dayIncTotal = dayIncTotal
        self.dayConsTotal = dayConsTotal
    }
}

struct IncConsDataByDay {
    // 収入・支出キー
    var incConsKey: String
    // 収入・支出フラグ
    var incConsFlg: Int
    // 日付
    var date: Date
    // 金額
    var amount: Int
    // 収入・支出項目
    var secModel: IncConsSecionModel
    // 収入・支出カテゴリー
    var catgModel: IncConsCategoryModel
    // 連携されている残高主キー配列
    var linkBalArray: [IncConsLinkBalModel]
    // イニシャライザ
    init(incConsKey: String, incConsFlg: Int, date: Date, amount: Int, secModel: IncConsSecionModel, catgModel: IncConsCategoryModel, linkBalArray: [IncConsLinkBalModel]) {
        self.incConsKey = incConsKey
        self.incConsFlg = incConsFlg
        self.date = date
        self.amount = amount
        self.secModel = secModel
        self.catgModel = catgModel
        self.linkBalArray = linkBalArray
    }
}

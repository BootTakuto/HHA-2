//
//  UtilitiesViewModel.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/14.
//

import Foundation

struct CommonViewModel {
    
     /* 日付を任意のフォーマットに変換
      -param date 日付
      -param format 日付表示フォーマット
      -return フォーマット適応後の日付情報
      */
    func getFormatDate(format: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    /* 金額に応じて単位を変更する（チャートラベル用）
     -param amount 金額
     -return 単位を付与した金額
     */
    func getAmountWithJpUnit(amount: Int) -> String {
        var amountWithJpUnit = "¥" + String(amount)
        let tenThousand = 10000
        let oneHundredMillion = 100000000
        if amount > tenThousand {
            amountWithJpUnit = "¥" + String(amount / tenThousand) + "万"
        } else if amount > oneHundredMillion {
            amountWithJpUnit = "¥" + String(amount / oneHundredMillion) + "億"
        }
        return amountWithJpUnit
    }
}

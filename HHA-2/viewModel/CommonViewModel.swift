//
//  CommonViewModel.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/10/01.
//

import Foundation
import RealmSwift
import SwiftUI

class CommonViewModel {
    
    let realm = try! Realm()
    
     /*
      日付を任意のフォーマットに変換
      -param date 日付
      -param format 日付表示フォーマット
      -return フォーマット適応後の日付情報
      */
    func getFormatDate(format: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    /*
     金額に応じて単位を変更する（チャートラベル用）
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
    
    /*
     行と列からインデックスを取得する
     -param a 行数または列数
     -param b aが行数の場合、列数、aが列数の場合、行数
     -return 連番（インデックス）
     */
    static func getRowColIndex(_ a: Int, _ b: Int, _ cnt: Int) -> Int {
        return a + (b * cnt)
    }
    
    /*
     16進数のカラーコードを元にRGB値を辞書形式で取得する
     -param hex 16進数カラーコード
     -return RGB値辞書
     */
    static func getRGBFromHex(hex: String) -> [String: Double] {
        // 左からr・g・bで格納
        var rgbDictionary = ["red": 0.0, "green": 0.0, "blue": 0.0]
        // red
        let red = Double(Int(hex.prefix(2), radix: 16) ?? 0)
        rgbDictionary["red"] = red
        // green
        let greenStart = hex.index(hex.startIndex, offsetBy: 2)
        let greenEnd = hex.index(hex.startIndex, offsetBy: 3)
        let green = Double(Int(String(hex[greenStart...greenEnd]), radix: 16) ?? 0)
        rgbDictionary["green"] = green
        // blue
        let blue = Double(Int(hex.suffix(2), radix: 16) ?? 0)
        rgbDictionary["blue"] = blue
        return rgbDictionary
    }
    
    /*
     16進数のカラーコードを元にカラーを取得する
     -param hex 16s進数カラーコード
     -return カラー
     */
    static func getColorFromHex(hex: String) -> Color {
        let rgbDictionary: [String: Double] = getRGBFromHex(hex: hex)
        let red = rgbDictionary["red"]!
        let green = rgbDictionary["green"]!
        let blue = rgbDictionary["blue"]!
        return Color(red: red / 255.0, green: green / 255.0, blue: blue / 255.0)
    }
    
    /*
     アクセントカラーを取得する
     -return アクセントカラー
     */
    static func getAccentColor() -> Color {
        @AppStorage("ACCENT_COLOR") var hex: String = "FECB3E"
        let rgbDictionary: [String: Double] = getRGBFromHex(hex: hex)
        let red = rgbDictionary["red"]!
        let green = rgbDictionary["green"]!
        let blue = rgbDictionary["blue"]!
        return Color(red: red / 255.0, green: green / 255.0, blue: blue / 255.0)
        
    }
    
    /*
     アクセントカラーの相対輝度に応じた文字色を取得
     -- return 文字色
     */
    static func getTextColor() -> Color {
        @AppStorage("ACCENT_COLOR") var accentColorHex: String = "FECB3E"
        var textColor: Color = .white
        let rgbDictionary: [String: Double] = getRGBFromHex(hex: accentColorHex)
        let red = rgbDictionary["red"]! / 255
        let green = rgbDictionary["green"]! / 255
        let blue = rgbDictionary["blue"]! / 255
        // 相対輝度を取得
        let relativeLuminace = 0.2126 * red + 0.7152 * green + 0.0722 * blue
       
        if relativeLuminace >= 0.5 {
            textColor = .black
        }
        
        return textColor
    }
    
}

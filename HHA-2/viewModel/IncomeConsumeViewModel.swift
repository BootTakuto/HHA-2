//
//  IncomeConsumeViewModel.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/11/21.
//

import Foundation
import SwiftUI
import RealmSwift

class IncomeConsumeViewModel: CommonViewModel {
    
    let monthFormat = "yyyyMM"
    
    /*
     選択月の取得
     -param 画面で選択された日付
     -return 選択月
     */
    func getSelectedMonth(selectedDate: Date) -> String {
        return getFormatDate(format: monthFormat, date: selectedDate)
    }
    
    /*
     登録済みの収入・支出情報を取得
     -param month 選択月
     -return
     */
    func getIncConsListByMonth(selectedDate: Date) -> Results<IncConsModel> {
        let month = getSelectedMonth(selectedDate: selectedDate)
        let filterPredicate = NSPredicate(format: "incConsDate LIKE %@", "*\(month)*")
        @ObservedResults(IncConsModel.self, filter: filterPredicate) var results
        return results
    }
    
    /*
     収入・支出の各項目別合計金額と項目データを取得
     -param selectedDate 選択されている日付
     -return 表示用データ配列
     */
    func getIncConsDataBySecArray(selectedDate: Date, incConsFlg: Int) -> [IncConsDataBySec] {
        // 返却用配列
        var dataArray = [IncConsDataBySec]()
        // 選択日付から月毎のレコードを取得
        let results = getIncConsListByMonth(selectedDate: selectedDate)
        // 収入・支出どちらかのレコードを取得
        let incConsResults = results.where({$0.incConsFlg == incConsFlg})
        // 収入・支出どちらかのレコードから項目キーのみを配列に格納（重複は除く）
        let distSecArray = Array(incConsResults).map({$0.incConsSecKey}).uniqued()
        distSecArray.forEach { secKey in
            // 項目ごとの合計金額を算出
            let resultsBySec = incConsResults.where({$0.incConsSecKey == secKey})
            let incTotal =  resultsBySec.sum(of: \.incConsAmt)
            // 項目別データの作成
            let incConsDataBySec = IncConsDataBySec(incConsFlg: incConsFlg,
                                      secModel: realm.object(ofType: IncConsSecionModel.self, forPrimaryKey: secKey)!,
                                      amtTotal: incTotal)
            dataArray.append(incConsDataBySec)
        }
        return dataArray
    }
    
    /*
     登録済みの収入・支出情報を項目別の表示用データ（辞書型）として取得
     -param month 選択月
     -param dataKind 取得データの種類（0:収支全て,1:収入すべて,2:支出すべて）
     -return 表示用データ
     */
    func getIncConsDic(selectedDate: Date) -> [Int: [IncConsDataBySec]] {
        // 返却用辞書
        var dic = [Int: [IncConsDataBySec]]()
        /* ▼収入表示データの作成 */
        dic[0] = getIncConsDataBySecArray(selectedDate: selectedDate, incConsFlg: 0)
        /* ▼支出表示データの作成 */
        dic[1] = getIncConsDataBySecArray(selectedDate: selectedDate, incConsFlg: 1)
        
        return dic
    }
    
    /*
     収入または支出合計金額を表示する
     -param month 選択月
     -param incConsFlg 収入・支出フラグ
     -return 収入または支出合計金額
     */
    func getIncOrConsMonthlyTotal(selectedDate: Date, incConsFlg: Int) -> Int {
        let results = getIncConsListByMonth(selectedDate: selectedDate)
        let incConsResults = results.where({$0.incConsFlg == incConsFlg})
        return incConsResults.sum(of: \.incConsAmt)
    }
    
    /*
     収入・支出円チャート用データ配列の作成
     -param incConsFlg 収入・支出フラグ
     -return 収入・支出円チャート用データ
     */
    func getIncConsPieDataArray(incConsFlg: Int, selectedDate: Date) -> [PieData] {
        // 返却用配列
        var pieDataArray = [PieData]()
        // 収入・支出別の項目別情報の作成
        let incConsBySecArray: [IncConsDataBySec] = getIncConsDataBySecArray(selectedDate: selectedDate, incConsFlg: incConsFlg)
        // 収入・支出別月間の合計金額
        let monthlyTotal = getIncOrConsMonthlyTotal(selectedDate: selectedDate, incConsFlg: incConsFlg)
        if monthlyTotal > 0 && !incConsBySecArray.isEmpty {
            incConsBySecArray.forEach { dataBySec in
                let secModel = dataBySec.secModel
                // 各項目の金額が占める割合を算出
                let dMonthTotal = Double(monthlyTotal)
                let dSecTotal = Double(dataBySec.amtTotal)
                let ratio = NSDecimalNumber(string: String(dSecTotal)).dividing(by: NSDecimalNumber(string: String(dMonthTotal)))
                // チャート背景色の作成
                let bgColor = CommonViewModel.getColorFromHex(hex: secModel.iconColorHex)
                // チャート用データの作成
                let pieData = PieData(id: secModel.secKey,
                                      valNm: secModel.secNm,
                                      value: dataBySec.amtTotal,
                                      ratio: Double(truncating: ratio) * 100.0,
                                      bgColor: bgColor)
                
                pieDataArray.append(pieData)
            }
        }
        return pieDataArray
    }
}

/*
 収入・支出項目別データ
 */
struct IncConsDataBySec {
    // 収入・支出フラグ
    var incConsFlg: Int
    // 収入・支出項目モデル
    var secModel: IncConsSecionModel
    // 項目ごとの金額登録
    var amtTotal: Int
    // イニシャライザ
    init(incConsFlg: Int, secModel: IncConsSecionModel, amtTotal: Int) {
        self.incConsFlg = incConsFlg
        self.secModel = secModel
        self.amtTotal = amtTotal
    }
}

struct PieData {
    // id
    var id: String
    // 項目名
    var valNm: String
    // 値
    var value: Int
    // 割合（四捨五入）
    var ratio: Int
    // 背景色
    var bgColor: Color
    // イニシャライザ
    init(id: String, valNm: String, value: Int, ratio: Double, bgColor: Color) {
        self.id = id
        self.valNm = valNm
        self.value = value
        self.ratio = Int(round(ratio))
        self.bgColor = bgColor
    }
}

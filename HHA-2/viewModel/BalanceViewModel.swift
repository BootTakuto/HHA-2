//
//  BalanceViewModel.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/10/13.
//

import Foundation
import RealmSwift

class BalanceViewModel: CommonViewModel {
    /*
     残高の登録を行います
     @param balanceModel 残高登録モデル
     */
    func reigstBalance(balanceModel: BalanceModel) -> Bool {
        do {
            try realm.write() {
                realm.add(balanceModel)
            }
            return true
        } catch {
            return false
        }
    }
    
    /*
     残高の合計金額を取得します。
     -return 残高の合計
     */
    func getBalTotal() -> Int {
        var total = 0
        let results = realm.objects(BalanceModel.self)
        results.forEach { obj in
            total += obj.balAmount
        }
        return total
    }
    
    /*
     表示用資産・負債残高を取得（key: 資産or負債　文字列, value: 残高リスト）
     -return 表示用資産・負債残高辞書
     */
    func getBalanceDic() -> [Int: Results<BalanceModel>] {
        var dic = [Int: Results<BalanceModel>]()
        let assetResults = realm.objects(BalanceModel.self).where({$0.assetDebtFlg == 0})
        dic[0] = assetResults
        let debtResults = realm.objects(BalanceModel.self).where({$0.assetDebtFlg == 1})
        dic[1] = debtResults
        return dic
    }
}

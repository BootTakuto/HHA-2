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
    func reigstBalance(balanceModel: BalanceModel) {
        try! realm.write() {
            realm.add(balanceModel)
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
     残高のやり取りを取得
     -param
     -return 
     */
}

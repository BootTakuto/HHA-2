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
     主キーから残高を選択
     -param balKey 残高主キー
     -return 残高
     */
    func getBalanceModel(balKey: String) -> BalanceModel {
        return realm.object(ofType: BalanceModel.self, forPrimaryKey: balKey)!
    }
    
    /*
     残高の合計金額を取得します。
     -return 残高の合計
     */
    func getBalTotalDic() -> [Int: Int] {
        var totalDic: [Int: Int] = [0:0, 1:0, 2:0]
        let results = realm.objects(BalanceModel.self)
        results.forEach { obj in
            if obj.assetDebtFlg == 0 {
                totalDic[0]! += obj.balAmount
            } else {
                totalDic[1]! += obj.balAmount
            }
        }
        totalDic[2]! = totalDic[0]! - totalDic[1]!
        return totalDic
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
    
    /*
     残高情報を更新
     -param balModel 残高情報
     -return 成功フラグ
     */
    func updateBalance(balModel: BalanceModel) -> Bool {
        print(balModel.balKey == "" ? "空" : balModel.balKey)
        if balModel.balKey == "" {
            return false
        }
        let targetBalModel = realm.object(ofType: BalanceModel.self, forPrimaryKey: balModel.balKey)
        do {
            try realm.write() {
                targetBalModel!.assetDebtFlg = balModel.assetDebtFlg
                targetBalModel!.balName = balModel.balName
                targetBalModel!.balColorHex = balModel.balColorHex
                targetBalModel!.balAmount = balModel.balAmount
            }
            return true
        } catch {
            return false
        }
    }
    
    /*
     残高を削除
     -param balKey 主キー
     */
    func deleteBalanceModel(balKey: String) {
        let balModel = realm.object(ofType: BalanceModel.self, forPrimaryKey: balKey)
        do {
            try realm.write() {
                if let unWrapModel = balModel {
                    realm.delete(unWrapModel)
                }
            }
        } catch {
            print("balance delete error")
        }
    }
    
}

struct BalanceTotalData {
    var assetsTotal = 0
    var debtTotal = 0
    var netTotal = 0
    init(assetsTotal: Int = 0, debtTotal: Int = 0, netTotal: Int = 0) {
        self.assetsTotal = assetsTotal
        self.debtTotal = debtTotal
        self.netTotal = netTotal
    }
}

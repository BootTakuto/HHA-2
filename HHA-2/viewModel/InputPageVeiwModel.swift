//
//  BalanceViewModel.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/10/10.
//

import Foundation
import RealmSwift

class InputPageVeiwModel: CommonViewModel {
//    /*
//    連携される残高が選択されているか否かを判定
//     */
//    func isSelectedLinkBal(linkBalArray: [LinkBalanaceData]) -> Bool {
//        var isSelected = false
//        linkBalArray.forEach { linkBalData in
//            if linkBalData.isSelected {
//                isSelected = true
//                return
//            }
//        }
//        return isSelected
//    }
    /*
     連携残高選択用リストを取得します
     */
    func getLinkBalArray() -> [LinkBalanaceData] {
        var linkBalArray = [LinkBalanaceData]()
        realm.objects(BalanceModel.self).forEach { balModel in
            linkBalArray.append(LinkBalanaceData(balModel: balModel))
        }
        return linkBalArray
    }
    
    func getBalModelByKey(balKey: String) -> BalanceModel {
        return realm.object(ofType: BalanceModel.self, forPrimaryKey: balKey) ?? BalanceModel()
    }
    
    /*
     収入・支出カテゴリーの初期データ取得
     */
    func getIncConsCatgInitData(incConsFlg: Int) -> IncConsCategoryModel {
        let isIncome = incConsFlg == 0
        var catgModel = IncConsCategoryModel()
        @ObservedResults(IncConsSecionModel.self, where: {$0.isIncome == isIncome}) var secResults
        if !secResults.isEmpty {
            let sectionModel = secResults[0]
            @ObservedResults(IncConsCategoryModel.self, where: {$0.secKey == sectionModel.secKey}) var catgResults
            catgModel = catgResults[0]
        }
        return catgModel
    }
    
    /*
     収入・支出を登録します
     -param 収入・支出モデル
     */
    func registIncCons(incConsModel: IncConsModel) -> Bool {
        do {
            try realm.write() {
                realm.add(incConsModel)
            }
            return true
        } catch {
            return false
        }
    }
}

/*
 残高連携入力用表示モデル
 */
struct LinkBalanaceData {
    // 入力金額
    var inputAmt: String = "0"
    // 連携残高情報
    var balModel: BalanceModel
    // オーバーライド
    init(balModel: BalanceModel) {
        self.balModel = balModel
    }
}

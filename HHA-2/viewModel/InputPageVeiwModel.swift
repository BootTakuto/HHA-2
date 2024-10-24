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
            linkBalArray.append(LinkBalanaceData(isSelected: false, balModel: balModel))
        }
        return linkBalArray
    }
    
    func getBalModelByKey(balKey: String) -> BalanceModel {
        return realm.object(ofType: BalanceModel.self, forPrimaryKey: balKey) ?? BalanceModel()
    }
}

/*
 残高連携入力用表示モデル
 */
struct LinkBalanaceData {
    // 残高の連携有無
    var isSelected: Bool
    // 金額入力
    var inputAmt: String = "0"
    // 連携残高情報
    var balModel: BalanceModel
    // オーバーライド
    init(isSelected: Bool, balModel: BalanceModel) {
        self.isSelected = isSelected
        self.balModel = balModel
    }
}

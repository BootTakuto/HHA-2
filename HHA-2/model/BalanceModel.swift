//
//  BalanceModel.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/10/10.
//

import Foundation
import RealmSwift

class BalanceModel: Object, Identifiable {
    // 主キー
    @Persisted(primaryKey: true) var balKey: String = ""
    // 残高名
    @Persisted var balName: String = "不明"
    // 残高タグカラーコード（16進数）
    @Persisted var balColorHex: String = "E22400"
    // 残高金額
    @Persisted var balAmount: Int = 0
}

//struct BalanceModelStruct: Identifiable, Hashable {
//    var id: UUID
//    var balGroupKey: String
//    var balName: String
//    var balColorIndex: Int
//    var balAmount: Int
//    
//    init(balModel: BalanceModel) {
//        self.id = UUID(uuidString: balModel.balKey)!
//        self.balGroupKey = balModel.balGroupKey
//        self.balName = balModel.balName
//        self.balColorIndex = balModel.balColorIndex
//        self.balAmount = balModel.balAmount
//    }
//}

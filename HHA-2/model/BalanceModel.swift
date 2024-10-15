//
//  BalanceModel.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/10/10.
//

import Foundation
import RealmSwift

class BalanceModel: Object {
    // 主キー
    @Persisted(primaryKey: true) var balKey: String = ""
    // 残高グループキー
    @Persisted var balGroupKey: String = ""
    // 残高名
    @Persisted var balName: String = ""
    // 残高タグカラーインデックス
    @Persisted var balColorIndex: Int = 0
    // 残高金額
    @Persisted var balAmount: Int = 0

}

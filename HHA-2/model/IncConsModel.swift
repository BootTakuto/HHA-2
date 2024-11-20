//
//  IncConsModel.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/11/20.
//

import Foundation
import RealmSwift

class IncConsModel: Object {
    // 主キー
    @Persisted(primaryKey: true) var incConsKey: String
    // 収入・支出フラグ
    @Persisted var incConsFlg: Int
    // 収入・支出カテゴリーキー
    @Persisted var incConsCatgKey: String
    // 収入・支出残高連携フラグ
    @Persisted var isLinkBal: Bool
    // リンク残高と各残高の金額
    @Persisted var linkBalList :RealmSwift.List<IncConsLinkBalModel>
    // 収入・支出金額
    @Persisted var incConsAmt: String
    // 日付
    @Persisted var incConsDate: String
    // メモ
    @Persisted var incConsMemo: String
    
    convenience init(incConsKey: String, incConsFlg: Int, incConsCatgKey: String, isLinkBal: Bool, linkBalList: RealmSwift.List<IncConsLinkBalModel>, incConsAmt: String, incConsDate: String, incConsMemo: String) {
        self.init()
        self.incConsKey = incConsKey
        self.incConsFlg = incConsFlg
        self.incConsCatgKey = incConsCatgKey
        self.isLinkBal = isLinkBal
        if isLinkBal {
            self.linkBalList = .init()
            self.linkBalList.append(objectsIn: linkBalList)
        }
        self.incConsAmt = incConsAmt
        self.incConsDate = incConsDate
        self.incConsMemo = incConsMemo
    }
}

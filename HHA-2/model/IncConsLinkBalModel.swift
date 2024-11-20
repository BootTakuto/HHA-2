//
//  IncConsLinkBalModel.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/11/20.
//

import Foundation
import RealmSwift

class IncConsLinkBalModel: Object {
    // 連携残高主キー
    @Persisted var balKey: String
    // 収入・支出金額
    @Persisted var incConsAmt: String
    
    convenience init(balKey: String, incConsAmt: String) {
        self.init()
        self.balKey = balKey
        self.incConsAmt = incConsAmt
    }
}

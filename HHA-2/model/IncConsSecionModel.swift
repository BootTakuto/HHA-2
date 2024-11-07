//
//  IncConsSecionModel.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/10/27.
//

import Foundation
import RealmSwift

class IncConsSecionModel: Object, Identifiable {
    
    // 収入・支出項目主キー
    @Persisted(primaryKey: true) var secKey: String
    // 収入項目の当否（true: 収入項目、false: 支出項目）
    @Persisted var isIncome: Bool
    // 収入・支出項目名
    @Persisted var secNm: String
    // 収入・支出アイコンカラーコード（16進数）
    @Persisted var iconColorHex: String
    // 収入・支出アイコンイメージ名
    @Persisted var iconImageNm: String
    // 収入・支出カテゴリーリスト
    @Persisted var catgList: RealmSwift.List<IncConsCategoryModel>
    
    convenience init(secKey: String, isIncome: Bool, secNm: String, iconColorHex: String, iconImageNm: String, catgList: [IncConsCategoryModel]) {
        self.init()
        self.secKey = secKey
        self.isIncome = isIncome
        self.secNm = secNm
        self.iconColorHex = iconColorHex
        self.iconImageNm = iconImageNm
        self.catgList = .init()
        self.catgList.append(objectsIn: catgList)
    }
    
    
}

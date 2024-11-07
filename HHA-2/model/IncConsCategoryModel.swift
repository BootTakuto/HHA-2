//
//  IncConsCategoryModel.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/10/27.
//

import Foundation
import RealmSwift

class IncConsCategoryModel: Object, Identifiable {
    
    // 収入・支出カテゴリー主キー
    @Persisted(primaryKey: true) var catgKey: String
    // 収入・支出カテゴリー含有の項目主キー
    @Persisted var secKey: String
    // 収入・支出カテゴリー名
    @Persisted var catgNm: String
    
    convenience init(catgKey: String, secKey: String, catgNm: String) {
        self.init()
        self.catgKey = catgKey
        self.secKey = secKey
        self.catgNm = catgNm
    }
    
}

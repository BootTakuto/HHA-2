//
//  IncConSectionViewModel.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/10/28.
//

import Foundation
import RealmSwift

class IncConsSectionViewModel: CommonViewModel {
    
    /*
     収入・支出項目の登録
     -param incConsSecModel 収入・支出項目モデル
     */
    func registIncConsSec(sectionModel: IncConsSecionModel) {
        try! realm.write() {
            realm.add(sectionModel)
        }
    }
    
    /*
     収入または支出項目の取得
     -param isIncome 収入の当否
     -return 収入または支出項目リスト
     */
    func getIncOrConsSection(isIncome: Bool) -> Results<IncConsSecionModel> {
        @ObservedResults(IncConsSecionModel.self) var results
        return results.where({$0.isIncome == isIncome})
    }
    
}

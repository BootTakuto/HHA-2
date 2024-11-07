//
//  IncConsCategoryViewModel.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/10/30.
//

import Foundation
import RealmSwift

class IncConsCategoryViewModel: CommonViewModel {
    
    /*
     収入・支出カテゴリーの登録と項目が保持するカテゴリーリストへの登録
     -param categoryModel カテゴリーモデル
     */
    func registIncConsCatgList(categoryModel: IncConsCategoryModel) {
        let sectionModel = realm.object(ofType: IncConsSecionModel.self, forPrimaryKey: categoryModel.secKey)
        if let unWrappedSecModel = sectionModel {
            try! realm.write() {
                realm.add(categoryModel)
                unWrappedSecModel.catgList.append(categoryModel)
            }
        }
    }
    
    /*
     収入・支出カテゴリーの取得
     -param secKey カテゴリーを含有している項目主キー
     -return カテゴリーリスト
     */
    func getIncConsCatgList(secKey: String) -> Results<IncConsCategoryModel> {
        @ObservedResults(IncConsCategoryModel.self, where: {$0.secKey == secKey}) var results
        return results
    }
    
}

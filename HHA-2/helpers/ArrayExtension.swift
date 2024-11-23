//
//  ArrayExtension.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/11/23.
//

import Foundation

public extension Array where Element: Hashable {
    // 重複を排除する関数
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}

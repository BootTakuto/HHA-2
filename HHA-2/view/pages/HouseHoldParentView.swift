//
//  HouseHoldParentPage.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/12/21.
//

import SwiftUI

struct HouseHoldParentView: View {
    let tabData = [TabData(title: "収支", iconNm: ""),
                   TabData(title: "カレンダー", iconNm: "calendar"),
                   TabData(title: "", iconNm: "plus")]
    var body: some View {
        PageScrollView(pageData: tabData) {
            Text("")
                .containerRelativeFrame(.horizontal)
                .id(0)
        }
    }
}

#Preview {
    HouseHoldParentView()
}

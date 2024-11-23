//
//  Border.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/11/23.
//

import SwiftUI

struct Border: View {
    var color: Color = Color(uiColor: .systemGray3)
    var body: some View {
        RoundedRectangle(cornerRadius: .infinity)
            .fill(color)
            .frame(height: 1)
    }
}

#Preview {
    Border(color: .orange)
}

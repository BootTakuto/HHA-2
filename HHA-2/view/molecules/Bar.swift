//
//  Bar.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/18.
//

import SwiftUI

struct Bar: View {
    var color: Color = .gray
    var body: some View {
        RoundedRectangle(cornerRadius: .infinity)
            .fill(color)
            .frame(width: 1)
    }
}

#Preview {
    Bar(color: .orange)
}

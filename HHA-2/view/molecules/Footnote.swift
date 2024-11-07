//
//  Footnote.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/20.
//

import SwiftUI

struct Footnote: View {
    var text: String
    var color: Color = .gray
    var body: some View {
        Text(text)
            .font(.footnote)
            .foregroundStyle(color)
    }
}

#Preview {
    Footnote(text: "")
}

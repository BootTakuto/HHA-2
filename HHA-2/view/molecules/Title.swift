//
//  Header.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/12/22.
//

import SwiftUI

struct Title: View {
    var title: String
    var message: String
    init(title: String, message: String) {
        self.title = title
        self.message = message
    }
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title3)
                    .kerning(1)
                Footnote(text: message)
            }
            Spacer()
        }.padding(.horizontal, 20)
    }
}

#Preview {
    Title(title: "残高一覧", message: "資産・負債の残高を一覧で表示") 
}

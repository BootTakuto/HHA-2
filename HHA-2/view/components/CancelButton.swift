//
//  CancelButton.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/10/22.
//

import SwiftUI

struct CancelButton: View {
    var text: String
    var action: () -> ()
    var body: some View {
        RoundedButton(radius: 10, color: Color(uiColor: .systemGray5), text: text) {
            action()
        }.frame(height: 40)
    }
}

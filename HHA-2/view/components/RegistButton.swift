//
//  RegistButton.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/10/22.
//

import SwiftUI

struct RegistButton: View {
    let accentColor = CommonViewModel.getAccentColor()
    let textColor = CommonViewModel.getTextColor()
    var text: String = ""
    var isDisabled: Bool
    var action: () -> ()
    var body: some View {
        RoundedButton(radius: 10,
                      color: isDisabled ? Color(uiColor: .systemGray6) : accentColor,
                      text: text,
                      textColor: isDisabled ? .gray : textColor) {
            action()
        }.disabled(isDisabled)
    }
}

//#Preview {
//    RegistButton()
//}

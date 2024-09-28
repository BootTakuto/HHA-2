//
//  InputText.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/21.
//

import SwiftUI

struct InputText: View {
    var placeHolder = ""
    var alignment: TextAlignment = .leading
    var font: Font = .body
    var height: CGFloat = 50
    @Binding var text: String
    @FocusState var focus: Bool
    var body: some View {
        TextField(placeHolder, text: $text)
            .focused($focus)
            .font(font)
            .frame(height: height)
            .padding(.horizontal, 10)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(uiColor: .systemGray5))
            }.multilineTextAlignment(alignment)
            .onChange(of: focus) {
                if text != "" && focus {
                    self.text = ""
                }
            }
    }
}

#Preview {
    @Previewable @State var text = "0"
    InputText(placeHolder: "入力", alignment: .trailing, text: $text)
}

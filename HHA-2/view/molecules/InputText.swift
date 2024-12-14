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
    var isDispStroke = true
    var isDispShadow = true
    var body: some View {
        TextField(placeHolder, text: $text)
            .focused($focus)
            .font(font)
            .frame(height: height)
            .padding(.horizontal, 10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.changeable)
                    .overlay {
                        if isDispStroke {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 0.5)
                                .fill(.changeableStroke)
                        }
                    }.shadow(color: isDispShadow ? .changeableShadow.opacity(0.5) : .clear, radius: 10)
            }.multilineTextAlignment(alignment)
            .toolbar{
                ToolbarItem(placement: .keyboard){
                    HStack{
                        Spacer()
                        Button("完了"){
                            self.focus = false
                        }
                    }
                }
            }.onChange(of: focus) {
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

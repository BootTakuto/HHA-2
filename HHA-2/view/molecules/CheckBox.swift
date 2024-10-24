//
//  CheckBox.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/10/10.
//

import SwiftUI

struct CheckBox: View {
    @Binding var isChecked: Bool
    var accentColor: Color = CommonViewModel.getAccentColor()
    var textColor: Color = CommonViewModel.getTextColor()
    var text: String = ""
    var body: some View {
        GeometryReader {
            let size = $0.size
            HStack(spacing: 5) {
                RoundedRectangle(cornerRadius: 3)
                    .stroke(lineWidth: 1)
                    .frame(width: 15, height: 15)
                    .background(isChecked ? accentColor : .clear)
                    .overlay {
                        if isChecked {
                            Image(systemName: "checkmark")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .fontWeight(.heavy)
                                .foregroundStyle(textColor)
                        }
                    }
                Footnote(text: text)
                    .frame(width: size.width - (5 + 15 + 1)) // size + HStack spaing 5 + rect size 15 + line width 1
                    .lineLimit(1)
            }.onTapGesture {
                withAnimation(.linear(duration: 0.15)) {
                    isChecked.toggle()
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var isChecked = true
    CheckBox(isChecked: $isChecked, accentColor: .orange, text: "check")
}

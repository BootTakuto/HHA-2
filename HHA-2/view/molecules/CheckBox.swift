//
//  CheckBox.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/10/10.
//

import SwiftUI

struct CheckBox: View {
    @State var isChecked = false
    var accentColor: Color = CommonViewModel.getAccentColor()
    var textColor: Color = CommonViewModel.getTextColor()
    var text: String = ""
    var action: () -> ()
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
                    .frame(width: size.width - (5 + 15 + 1), alignment: .leading) // size + HStack spaing 5 + rect size 15 + line width 1
                    .lineLimit(1)
            }.onTapGesture {
                withAnimation(.linear(duration: 0.15)) {
                    isChecked.toggle()
                }
                withAnimation {
                    action()
                }
            }
        }
    }
}

struct CheckModel {
    var primaryKey: String
    var isChecked: Bool
    init(primaryKey: String, isChecked: Bool) {
        self.primaryKey = primaryKey
        self.isChecked = isChecked
    }
}

#Preview {
    @Previewable @State var id = 0
    CheckBox(text: "check") {
        print("a")
    }
}

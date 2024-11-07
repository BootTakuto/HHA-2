//
//  RadioButton.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/11/03.
//

import SwiftUI

struct Radio: View {
    @Binding var selectKey: String
    var indivisualKey: String = ""
    var accentColor: Color = CommonViewModel.getAccentColor()
    var textColor: Color = CommonViewModel.getTextColor()
    var text: String = ""
    var action: () -> ()
    var body: some View {
        GeometryReader {
            let size = $0.size
            HStack(spacing: 5) {
                Button(action: {
                    withAnimation {
                        self.selectKey = indivisualKey
                        action()
                    }
                }) {
                    Circle()
                        .stroke(lineWidth: 2)
                        .fill(accentColor)
                        .frame(width: 15, height: 15)
                        .overlay {
                            if selectKey == indivisualKey {
                                Circle()
                                    .fill(accentColor)
                                    .frame(width: 10, height: 10)
                                    .foregroundStyle(textColor)
                            }
                        }
                    Footnote(text: text)
                        .frame(width: size.width - (5 + 15 + 1), alignment: .leading) // size + HStack spaing 5 + rect size 15 + line width 1
                        .lineLimit(1)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectKey = "0"
    Radio(selectKey: $selectKey, indivisualKey: "0", text: "radio Button") {
        print("")
    }
}

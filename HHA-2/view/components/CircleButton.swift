//
//  CircleButton.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/10/26.
//

import SwiftUI

struct CircleButton: View {
    var text = ""
    var imageNm = ""
    var color = CommonViewModel.getAccentColor()
    var textColor = CommonViewModel.getTextColor()
    var action: () -> ()
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(color)
                .overlay {
                    VStack {
                        if imageNm != "" {
                            if text == "" {
                                Image(systemName: imageNm)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(text == "" ? 10 : 0)
                            } else {
                                Image(systemName: imageNm)
                            }
                        }
                        if text != "" {
                            Text(text)
                                .font(.system(size: 10))
                        }
                    }.foregroundStyle(textColor)
                }.compositingGroup()
                .shadow(color: .changeableShadow, radius: 5)
        }
    }
}

#Preview {
    CircleButton(imageNm: "plus") {
        
    }
}

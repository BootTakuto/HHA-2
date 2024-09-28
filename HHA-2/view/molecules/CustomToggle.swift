//
//  CustomToggle.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/20.
//

import SwiftUI

struct CustomToggle: View {
    @Binding var isOn: Bool
    var width: CGFloat = 50
    var color: Color = .green
    var body: some View {
        GeometryReader {
            let size = $0.size
            ZStack {
                RoundedRectangle(cornerRadius: .infinity)
                    .foregroundStyle(isOn ?  color.shadow(.inner(color: .gray, radius: 3)) :
                                        Color(uiColor: .systemGray5).shadow(.inner(color: .changeableShadow, radius: 3)))
                Circle()
                    .fill(.white)
                    .shadow(color: isOn ? .gray : .changeableShadow, radius: 3)
                    .frame(width: size.width / 2 - 5, height: size.width / 2 - 5)
                    .frame(maxWidth: size.width - 10, alignment: .leading)
                    .offset(x: isOn ? (size.width - 10) / 2 : 0)
            }.onTapGesture {
                withAnimation {
                    self.isOn.toggle()
                }
            }
        }.frame(width: width, height: width / 2)
    }
}

#Preview {
    @Previewable @State var isOn = false
    CustomToggle(isOn: $isOn)
}

//
//  Palette.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/10/20.
//

import SwiftUI

struct Palette: View {
    @Binding var hex: String
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0 ..< 10, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0 ..< 12, id: \.self) { col in
                        let index = CommonViewModel.getRowColIndex(col, row, 12)
                        let hex = CommonModel.colorHex[index]
                        Rectangle()
                            .fill(CommonViewModel.getColorFromHex(hex: hex))
                            .onTapGesture {
                                withAnimation {
                                    self.hex = hex
                                }
                            }
                    }
                }
            }
        }.clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    @Previewable @State var hex = ""
    Palette(hex: $hex)
}

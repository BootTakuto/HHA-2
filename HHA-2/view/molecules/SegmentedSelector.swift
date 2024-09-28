//
//  SelectTab.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/19.
//

import SwiftUI

struct SegmentedSelector: View {
    var accentColor: Color
    @Binding var selectedIndex: Int
    @State var elementRectOffset: CGFloat = 5
    var texts: [String]
    var body: some View {
        GeometryReader {
            let size = $0.size
            let elementWidth = size.width / CGFloat(texts.count)
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(uiColor: .systemGray5))
                RoundedRectangle(cornerRadius: 5)
                    .fill(accentColor)
                    .frame(width: elementWidth - 10, height: 18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(x: elementRectOffset)
                HStack(spacing: 0) {
                    ForEach(texts.indices, id: \.self) { index in
                        Text(texts[index])
                            .font(.footnote)
                            .frame(width: elementWidth)
                            .contentShape(Rectangle()) 
                            .onTapGesture {
                                withAnimation {
                                    self.selectedIndex = index
                                    self.elementRectOffset = elementWidth * CGFloat(index) + 5
                                }
                            }
                    }
                }
            }
        }.frame(height: 25)
    }
}

#Preview {
    @Previewable @State var selectedIndex = 0
    SegmentedSelector(accentColor: .orange, selectedIndex: $selectedIndex, texts: ["A", "B", "C"])
}

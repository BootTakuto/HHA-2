//
//  SelectTab.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/19.
//

import SwiftUI

struct SegmentedSelector: View {
    var accentColor: Color = CommonViewModel.getAccentColor()
    var accentTextColor: Color = CommonViewModel.getTextColor()
    @Binding var selectedIndex: Int
    @State var elementRectOffset: CGFloat = 5
    var texts: [String]
    var body: some View {
        GeometryReader {
            let size = $0.size
            let elementWidth = size.width / CGFloat(texts.count)
            ZStack {
                RoundedRectangle(cornerRadius: .infinity)
                    .fill(Color(uiColor: .systemGray6))
                RoundedRectangle(cornerRadius: .infinity)
                    .fill(accentColor)
                    .shadow(color: .changeableShadow, radius: 2)
                    .frame(width: elementWidth - 10, height: 25)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(x: elementRectOffset)
                HStack(spacing: 0) {
                    ForEach(texts.indices, id: \.self) { index in
                        let isSelected = self.selectedIndex == index
                        let selectedTextColor: Color = isSelected ? accentTextColor : .changeableText
                        Text(texts[index])
                            .font(.footnote)
                            .foregroundStyle(selectedTextColor)
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
        }.frame(height: 35)
    }
}

#Preview {
    @Previewable @State var selectedIndex = 0
    SegmentedSelector(selectedIndex: $selectedIndex, texts: ["A", "B", "C"])
}

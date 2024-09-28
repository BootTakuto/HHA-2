//
//  IncConsSelector.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/27.
//

import SwiftUI

struct SectionSelector: View {
    @Binding var selectIndex: Int
    @State var isShowSheet = false
    var height: CGFloat = 50
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color(uiColor: .systemGray5))
                .onTapGesture {
                    self.isShowSheet.toggle()
                }
            HStack {
                RoundedIcon()
                Spacer()
                Text("給与")
                    .foregroundStyle(.changeableText)
            }.padding(.horizontal, 20)
        }.frame(height: height)
            .floatingSheet(isPresented: $isShowSheet) {
                SectionList()
                    .presentationDetents([.height(300)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(300)))
            }
    }
    
    @ViewBuilder
    func SectionList() -> some View {
        let isSelectInc = selectIndex ==  0
        GeometryReader {
            let safeAreaInsetx = $0.safeAreaInsets
            ZStack {
                UnevenRoundedRectangle(topLeadingRadius: 10, topTrailingRadius: 10)
                    .fill(.changeable)
                    .padding(.top, 10)
                    .shadow(color: .changeableShadow, radius: 5)
                VStack(alignment: .leading, spacing: 5) {
                    Footnote(text: isSelectInc ? "収入項目" : "支出項目")
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(0 ..< 10, id: \.self) { index in
                                RoundedIcon()
                                    .compositingGroup()
                                    .shadow(color: .changeableShadow, radius: 3)
                            }
                        }.padding(10)
                    }.scrollIndicators(.hidden)
                    Footnote(text: "カテゴリー")
                    ScrollView() {
                        ForEach(0 ..< 5, id: \.self) { row in
                            HStack(spacing: 0) {
                                ForEach(0 ..< 2, id: \.self) { col in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color(uiColor: .systemGray5))
                                            .frame(height: 30)
                                    }.padding(.horizontal, 5)
                                }
                            }
                        }
                    }.scrollIndicators(.hidden)
                        .frame(height: 200)
                }.padding(.horizontal, 20)
            }.ignoresSafeArea()
        }
    }
}

#Preview {
    @Previewable @State var selectIndex = 0
    SectionSelector(selectIndex: $selectIndex)
}

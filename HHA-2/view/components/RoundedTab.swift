//
//  RoundedTab.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/12/14.
//

import SwiftUI

struct RoundedTab: View {
    @State var selectIndex = 0
    var tabDatas: [TabData]
    var buttonsData: [PageScrollViewButtonData]
    let accentColor: Color
    let accentTextColor: Color
    var scrollViewProxy: ScrollViewProxy
    var body: some View {
        GeometryReader {
            if let scrollViewWidth = $0.bounds(of: .scrollView(axis: .horizontal))?.width,
               scrollViewWidth > 0 {
                let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                let activeIndex = round(-minX / scrollViewWidth)
                HStack(alignment: .center, spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(tabDatas.indices, id: \.self) { index in
                            let data = tabDatas[index]
                            let isSelected = selectIndex == index
                            VStack(spacing: 0) {
                                Circle()
                                    .fill(isSelected ? accentColor : .clear)
                                    .frame(width: 25)
                                    .overlay {
                                        Image(systemName: data.iconNm)
                                            .foregroundStyle(isSelected ? accentTextColor : .gray)
                                    }
                                Text(isSelected ? data.title : "")
                                    .font(.caption)
                            }.frame(width: 80)
                                .onTapGesture {
                                    withAnimation {
                                        scrollViewProxy.scrollTo(index)
                                    }
                                }.offset(y: isSelected ? 0 : 6.5)
                        }
                    }.background {
                        RoundedRectangle(cornerRadius: .infinity)
                            .fill(.changeable)
                            .frame(height: 50)
                    }.onChange(of: activeIndex) {
                        withAnimation(.linear) {
                            self.selectIndex = Int(activeIndex)
                        }
                    }.compositingGroup()
                    .shadow(color: .changeableShadow, radius: 5)
                    ForEach(buttonsData.indices, id: \.self) {index in
                        let data = buttonsData[index]
                        CircleButton(text: data.label,
                                     imageNm: data.imageNm,
                                     color: data.bgColor,
                                     textColor: data.textColor,
                                     action: data.action)
                        .frame(width: 40)
                    }.padding(.leading, 10)
                }.frame(width: scrollViewWidth, height: 60)
                    .offset(x: -minX)
            }
        }.frame(height: 60)
    }
}

//#Preview {
//    @Previewable @State var selectedIndex = 0
//    let tabDatas = [TabData(title: "一覧", iconNm: "list.bullet"),
//                    TabData(title: "追加", iconNm: "plus"),
//                    TabData(title: "追加", iconNm: "plus")]
//    RoundedTab(selectIndex: $selectedIndex,
//               tabDatas: tabDatas,
//               accentColor: .yellow,
//               accentTextColor: .black)
//}

#Preview {
    PageScrollView(pageData: [TabData(title: "一覧", iconNm: "list.bullet"),
                              TabData(title: "追加", iconNm: "plus"),
                              TabData(title: "追加", iconNm: "plus")],
                   buttonsData: [PageScrollViewButtonData(label: "入力",
                                                          imageNm: "square.and.pencil",
                                                          bgColor: .yellow,
                                                          textColor: .black,
                                                          action: {print("aaaaa")}),
                                 PageScrollViewButtonData(label: "使い方",
                                                          imageNm: "questionmark",
                                                          bgColor: .yellow,
                                                          textColor: .black,
                                                          action: {print("aaaaa")})]) {
        Text("aaaa")
            .containerRelativeFrame(.horizontal)
            .id(0)
        Text("bbbb")
            .containerRelativeFrame(.horizontal)
            .id(1)
        Text("cccc")
            .containerRelativeFrame(.horizontal)
            .id(2)
    }
}

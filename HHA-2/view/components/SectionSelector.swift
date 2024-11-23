//
//  IncConsSelector.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/27.
//

import SwiftUI

struct SectionSelector: View {
    
    @Binding var selectIndex: Int
    @Binding var catgModel: IncConsCategoryModel
    /* ▼表示データ */
    @State var isIncome = true
    @State var isShowSheet = false
    @State var incConsSecList = IncConsSectionViewModel().getIncOrConsSection(isIncome: true)
    @State var selectViewModel = SelectSecCatgViewModel()
    @State var selectSecModel = IncConsSecionModel()
    @State var selectCatgKey = ""
    var height: CGFloat = 50
    var isDispStroke = true
    var isDispShadow = true
    let viewModel = IncConsSectionViewModel()
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.changeable)
                .overlay {
                    if isDispStroke {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 0.5)
                            .fill(.changeableStroke)
                    }
                }.shadow(color: isDispShadow ? .changeableShadow.opacity(0.5) : .clear, radius: 10)
                .onTapGesture {
                    self.isShowSheet.toggle()
                }
            HStack {
                if incConsSecList.isEmpty {
                    Footnote(text: isIncome ? "収入項目は存在しません。" : "支出項目は存在しません。")
                } else {
                    RoundedIcon(image: selectViewModel.imageNm,
                                rectColor: selectViewModel.iconColor,
                                iconColor: selectViewModel.imageColor, rectSize: 35)
                    Spacer()
                    Text(selectViewModel.catgNm + "(" + selectViewModel.secNm + ")")
                        .foregroundStyle(.changeableText)
                }
            }.padding(.horizontal, 10)
        }.frame(height: height)
            .floatingSheet(isPresented: $isShowSheet) {
                SectionList()
                    .presentationDetents([.height(310)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(310)))
            }.onAppear {
                self.isIncome = selectIndex == 0
                if !incConsSecList.isEmpty {
                    self.selectSecModel = incConsSecList[0]
                    let categoryModel = selectSecModel.catgList[0]
                    self.selectViewModel = SelectSecCatgViewModel(sectionModel: selectSecModel,
                                                             categoryMdoel: categoryModel)
                    self.selectCatgKey = categoryModel.catgKey
                }
            }.onChange(of: selectIndex) {
                withAnimation {
                    self.isIncome = selectIndex == 0
                    self.incConsSecList = viewModel.getIncOrConsSection(isIncome: isIncome)
                    if !incConsSecList.isEmpty {
                        self.selectSecModel = incConsSecList[0]
                        let categoryModel = selectSecModel.catgList[0]
                        self.selectViewModel = SelectSecCatgViewModel(sectionModel: selectSecModel,
                                                                 categoryMdoel: categoryModel)
                        self.selectCatgKey = categoryModel.catgKey
                    }
                }
            }.disabled(incConsSecList.isEmpty)
    }
    
    @ViewBuilder
    func SectionList() -> some View {
        let catgList = selectSecModel.catgList
        let rowCount = catgList.count > 1 && catgList.count % 3 > 0 ? catgList.count + (3 - catgList.count) : catgList.count
        ZStack {
            UnevenRoundedRectangle(topLeadingRadius: 10, topTrailingRadius: 10)
                .fill(.changeable)
                .padding(.top, 10)
                .shadow(color: .changeableShadow, radius: 5)
            VStack(alignment: .leading, spacing: 5) {
                Footnote(text: isIncome ? "収入項目" : "支出項目")
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(0 ..< incConsSecList.count, id: \.self) { index in
                            let model = incConsSecList[index]
                            let rectColor = CommonViewModel.getColorFromHex(hex: model.iconColorHex)
                            let iconColor = CommonViewModel.getTextColorFromHex(hex: model.iconColorHex)
                            RoundedIcon(image: model.iconImageNm,
                                        text: model.secNm,
                                        rectColor: rectColor,
                                        iconColor: iconColor,
                                        rectSize: 45)
                                .compositingGroup()
                                .shadow(color: .changeableShadow, radius: 3)
                                .onTapGesture {
                                    withAnimation {
                                        self.selectSecModel = model
                                        self.selectViewModel = SelectSecCatgViewModel(sectionModel: model,
                                                                                      categoryMdoel: model.catgList[0])
                                        self.selectCatgKey = model.catgList[0].catgKey
                                        // 収入・支出の登録用カテゴリーデータを作成
                                        self.catgModel = model.catgList[0]
                                    }
                                }
                        }
                    }.padding(10)
                }.scrollIndicators(.hidden)
                Footnote(text: "カテゴリー")
                ScrollView() {
                    ForEach(0 ..< rowCount, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0 ..< 3, id: \.self) { col in
                                let index = CommonViewModel.getRowColIndex(col, row, 3)
                                let isIndexBellowListCount = catgList.count > index
                                if isIndexBellowListCount {
                                    let categoryModel = catgList[index]
                                    Radio(selectKey: $selectCatgKey,
                                          indivisualKey: categoryModel.catgKey,
                                          accentColor: selectViewModel.iconColor,
                                          text: categoryModel.catgNm) {
                                        // ビュー表示用データの作成
                                        self.selectViewModel.secKey = categoryModel.secKey
                                        self.selectViewModel.catgKey = categoryModel.catgKey
                                        self.selectViewModel.catgNm = categoryModel.catgNm
                                        // 収入・支出の登録用カテゴリーデータを作成
                                        self.catgModel = categoryModel
                                    }.padding(.bottom, 10)
                                } else {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(.clear)
                                        .frame(height: 30)
                                        .padding(.horizontal, 5)
                                }
                            }
                        }.padding(.horizontal, 10)
                            .padding(.vertical, 1)
                    }
                }.scrollIndicators(.hidden)
                    .frame(height: 200)
            }.padding(.horizontal, 10)
        }.ignoresSafeArea()
    }
}

// 選択項目用モデル
struct SelectSecCatgViewModel {
    // 項目主キー
    var secKey: String = ""
    // カテゴリー主キー
    var catgKey: String = ""
    // 項目名
    var secNm: String = ""
    // カテゴリー名
    var catgNm: String = ""
    // アイコン背景色
    var iconColor: Color = .clear
    // アイコンイメージ名
    var imageNm: String = ""
    // イメージカラー
    var imageColor: Color = .clear
}

extension SelectSecCatgViewModel {
    // イニシャライザ
    init(sectionModel: IncConsSecionModel,
         categoryMdoel: IncConsCategoryModel) {
        self.secKey = categoryMdoel.secKey
        self.catgKey = categoryMdoel.catgKey
        self.secNm = sectionModel.secNm
        self.catgNm = categoryMdoel.catgNm
        self.iconColor = CommonViewModel.getColorFromHex(hex: sectionModel.iconColorHex)
        self.imageNm = sectionModel.iconImageNm
        self.imageColor = CommonViewModel.getTextColorFromHex(hex: sectionModel.iconColorHex)
    }
}

#Preview {
    @Previewable @State var selectIndex = 0
    @Previewable @State var catgModel = IncConsCategoryModel()
    SectionSelector(selectIndex: $selectIndex, catgModel: $catgModel)
}

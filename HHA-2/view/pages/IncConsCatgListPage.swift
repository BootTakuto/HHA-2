//
//  IncConsCatgListPage.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/10/30.
//

import SwiftUI
import RealmSwift

struct IncConsCatgListPage: View {
    @Binding var isPesentedIncConsCatg: Bool
    var headerTitle: String
    var incConsSecModel: IncConsSecionModel
    @State var incConsCatgList: Results<IncConsCategoryModel> = IncConsCategoryViewModel().getIncConsCatgList(secKey: "")
    @State var isSheetShow = false
    // 入力情報
    @State var inputCatgNm = ""
    let viewModel = IncConsCategoryViewModel()
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                let size = proxy.size
                VStack(spacing: 0) {
                    NavigationHeader(title: headerTitle, isPresented: $isPesentedIncConsCatg, proxy: proxy, isShowInnerHeader: false)
                        .zIndex(1000)
                    IncConsCatgList()
                }.ignoresSafeArea()
                    .floatingSheet(isPresented: $isSheetShow) {
                        InputCategoryPopUp(size: size)
                            .presentationDetents([.fraction(0.999)])
                            .padding(.horizontal, 20)
                    }
            }
        }.navigationBarBackButtonHidden()
            .onAppear {
                self.incConsCatgList = viewModel.getIncConsCatgList(secKey: incConsSecModel.secKey)
            }
    }
    
    @ViewBuilder
    func IncConsCatgList() -> some View {
        ZStack {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(incConsCatgList.indices, id: \.self) { index in
                        let categoryModel = incConsCatgList[index]
                        CategoryCard(categoryModel: categoryModel)
                    }
                }.padding(.vertical, 20)
                    .padding(.bottom, 100)
            }.scrollIndicators(.hidden)
            AddButton()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
        }
    }
    
    @ViewBuilder
    func CategoryCard(categoryModel: IncConsCategoryModel) -> some View {
        Card {
            HStack {
                let color = CommonViewModel.getColorFromHex(hex: incConsSecModel.iconColorHex)
                let iconColor = CommonViewModel.getTextColorFromHex(hex: incConsSecModel.iconColorHex)
                RoundedIcon(image: incConsSecModel.iconImageNm, rectColor: color, iconColor: iconColor)
                Spacer()
                Footnote(text: categoryModel.catgNm, color: .changeableText)
            }.padding(.horizontal, 10)
        }.frame(height: 50)
            .padding(.horizontal, 15)
    }
    
    @ViewBuilder
    func InputCategoryPopUp(size: CGSize) -> some View {
        Card {
            VStack(spacing: 0) {
                Text("カテゴリーの追加")
                    .foregroundStyle(.changeableText)
                    .padding(.bottom, 5)
                    .padding(.top, 10)
                Footnote(text: "カテゴリー名")
                    .frame(width: size.width - 60, alignment: .leading)
                    .padding(.bottom, 5)
                InputText(placeHolder: "20文字以内", text: $inputCatgNm, isDispShadow: false)
                    .padding(.bottom, 10)
                RegistButton(text: "登録", isDisabled: inputCatgNm.isEmpty) {
                    let categoryModel = IncConsCategoryModel(catgKey: UUID().uuidString,
                                                             secKey: incConsSecModel.secKey,
                                                             catgNm: inputCatgNm)
                    viewModel.registIncConsCatgList(categoryModel: categoryModel)
                    self.incConsCatgList = viewModel.getIncConsCatgList(secKey: incConsSecModel.secKey)
                    self.isSheetShow = false
                }.frame(height: 40)
                    .padding(.bottom, 5)
                CancelButton(text: "閉じる") {
                    self.isSheetShow = false
                }.frame(height: 40)
            }.padding(.horizontal, 10)
                .frame(height: 220, alignment: .top)
        }.frame(height: 220)
    }
    
    @ViewBuilder
    func AddButton() -> some View {
        CircleButton(text: "追加", imageNm: "plus") {
            self.isSheetShow = true
        }.frame(width: 60)
    }
}

#Preview {
    @Previewable @State var isPresented = false
    IncConsCatgListPage(isPesentedIncConsCatg: $isPresented,
                        headerTitle: "Destination Page",
                        incConsSecModel: IncConsSecionModel())
}

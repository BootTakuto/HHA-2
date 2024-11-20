//
//  IncConsSecList.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/10/25.
//

import SwiftUI
import RealmSwift

struct IncConsSecListPage: View {
    @Binding var isPresetntedIncConsSec: Bool
    @State var isShowHeader = true
    @State var selectedIndex = 0
    @State var isSheetShow = false
    @State var isPresentedIncConsCatg = false
    // 登録情報
    @State var inputSecNm = ""
    @State var iconColorHex = CommonModel.colorHex[0]
    @State var iconImageNm = CommonModel.imageNames[0]
    @State var incConsSecList: Results<IncConsSecionModel> = IncConsSectionViewModel().getIncOrConsSection(isIncome: true)
    @State var incConsSecModel = IncConsSecionModel()
    let viewModel = IncConsSectionViewModel()
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                let size = proxy.size
                VStack(spacing: 0) {
                    IncConsSelectHeader(proxy: proxy)
                        .zIndex(1000)
                    IncConsSecList()
                }.ignoresSafeArea()
                .floatingSheet(isPresented: $isSheetShow) {
                    InputSectionPopUp(size: size)
                        .presentationDetents([.fraction(0.999)])
                        .padding(.horizontal, 20)
                }
            }.onChange(of: selectedIndex) {
                withAnimation {
                    self.incConsSecList = viewModel.getIncOrConsSection(isIncome: selectedIndex == 0)
                }
            }
        }.navigationDestination(isPresented: $isPresentedIncConsCatg) {
            IncConsCatgListPage(isPesentedIncConsCatg: $isPresentedIncConsCatg,
                                headerTitle: selectedIndex == 0 ? "収入カテゴリー" : "支出カテゴリー",
                                incConsSecModel: incConsSecModel)
        }.navigationBarBackButtonHidden()
    }
    
    @ViewBuilder
    func IncConsSelectHeader(proxy: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            NavigationHeader(title: "収入・支出項目", isPresented: $isPresetntedIncConsSec,
                             proxy: proxy, isLastPage: false)
                    .zIndex(100)
            InnerHeader(isShow: $isShowHeader, isAbleShrink: false, hiddenOffset: 0, height: 50) {
                SegmentedSelector(selectedIndex: $selectedIndex, texts: ["収入", "支出"])
                    .frame(width: 200)
            }
        }
    }
    
    @ViewBuilder
    func IncConsSecList() -> some View {
        let isIncSec = selectedIndex == 0
        ZStack {
            if incConsSecList.isEmpty {
                Footnote(text: isIncSec ?  "収入項目は存在しません。" : "支出項目は存在しません。")
            } else {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(incConsSecList.indices, id: \.self) { index in
                            let secModel = incConsSecList[index]
                            SectionCard(sectionModel: secModel)
                        }
                    }.padding(.vertical, 20)
                }
            }
            AddButton()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
        }
    }
    
    @ViewBuilder
    func SectionCard(sectionModel: IncConsSecionModel) -> some View {
        Card {
            HStack {
                let color = CommonViewModel.getColorFromHex(hex: sectionModel.iconColorHex)
                let iconColor = CommonViewModel.getTextColorFromHex(hex: sectionModel.iconColorHex)
                RoundedIcon(image: sectionModel.iconImageNm, rectColor: color, iconColor: iconColor)
                Spacer()
                Footnote(text: sectionModel.secNm, color: .changeableText)
                ImageLabel("chevron.right")
            }.padding(.horizontal, 10)
        }.frame(height: 50)
            .padding(.horizontal, 15)
            .onTapGesture {
                self.incConsSecModel = sectionModel
                self.isPresentedIncConsCatg = true
            }
        
    }
    
    @ViewBuilder
    func ImageLabel(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.footnote)
            .foregroundStyle(.changeableText)
    }
    
    @ViewBuilder
    func InputSectionPopUp(size: CGSize) -> some View {
        let isIncSec = selectedIndex == 0
        Card {
            VStack(spacing: 0) {
                Text(isIncSec ? "収入項目の登録" : "支出項目の登録")
                    .foregroundStyle(.changeableText)
                    .padding(.bottom, 5)
                    .padding(.top, 10)
                Footnote(text: "項目名")
                    .frame(width: size.width - 60, alignment: .leading)
                    .padding(.bottom, 5)
                InputText(placeHolder: "20文字以内", text: $inputSecNm, isDispShadow: false)
                    .padding(.bottom, 10)
                Footnote(text: "項目アイコンカラー")
                    .frame(width: size.width - 60, alignment: .leading)
                    .padding(.bottom, 5)
                ScrollView {
                    VStack {
                        Palette(hex: $iconColorHex)
                    }.frame(height: 320)
                }.clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(height: 150)
                    .scrollIndicators(.hidden)
                    .padding(.bottom, 10)
                Footnote(text: "項目イメージ")
                    .frame(width: size.width - 60, alignment: .leading)
                    .padding(.bottom, 5)
                ScrollView {
                    ImageNmList(size: size)
                        .frame(height: 150)
                }.frame(height: 150)
                    .scrollIndicators(.hidden)
                    .padding(.bottom, 10)
                RegistButton(text: "登録", isDisabled: inputSecNm.isEmpty) {
                    let secKey = UUID().uuidString
                    let categoryArray = [IncConsCategoryModel(catgKey: UUID().uuidString,
                                                              secKey: secKey,
                                                              catgNm: inputSecNm)]
                    let sectionModel = IncConsSecionModel(secKey: secKey,
                                                          isIncome: selectedIndex == 0,
                                                          secNm: inputSecNm,
                                                          iconColorHex: iconColorHex,
                                                          iconImageNm: iconImageNm,
                                                          catgList: categoryArray)
                    self.incConsSecList = viewModel.getIncOrConsSection(isIncome: selectedIndex == 0)
                    viewModel.registIncConsSec(sectionModel: sectionModel)
                    self.isSheetShow = false
                }.frame(height: 40)
                    .padding(.bottom, 5)
                CancelButton(text: "閉じる") {
                    self.isSheetShow = false
                }.frame(height: 40)
            }.padding(.horizontal, 10)
                .frame(height: 570, alignment: .top)
        }.frame(height: 570)
    }
    
    @ViewBuilder
    func ImageNmList(size: CGSize) -> some View {
        GeometryReader {
            let rectWidth = ($0.size.width - 33) / 10
            VStack(spacing: 3) {
                ForEach(0 ..< 4, id: \.self) { row in
                    HStack(spacing: 3) {
                        ForEach(0 ..< 10, id: \.self) { col in
                            let index = CommonViewModel.getRowColIndex(col, row, 10)
                            if CommonModel.imageNames.count > index {
                                let imageNm = CommonModel.imageNames[index]
                                let selectColor = CommonViewModel.getColorFromHex(hex: iconColorHex)
                                let isSelected = iconImageNm == imageNm
                                let textColor = CommonViewModel.getTextColorFromHex(hex: iconColorHex)
                                Card(cardColor: isSelected ? selectColor : .clear,
                                     shadowColor: isSelected ? .changeableShadow : .clear,
                                     shadowRadius: isSelected  ? 3 : 0) {
                                    Image(systemName: imageNm)
                                        .resizable()
                                        .scaledToFit()
                                        .padding(8)
                                        .foregroundStyle(isSelected ? textColor : .gray)
                                }.frame(width: rectWidth, height: rectWidth)
                                    .onTapGesture {
                                        withAnimation {
                                            self.iconImageNm = imageNm
                                        }
                                    }
                            } else {
                                Rectangle()
                                    .foregroundStyle(.clear)
                                    .frame(width: rectWidth, height: rectWidth)
                            }
                        }
                    }
                }
            }.padding(3)
        }
    }
    
    @ViewBuilder
    func AddButton() -> some View {
        CircleButton(text: "追加", imageNm: "plus") {
            self.isSheetShow = true
        }.frame(width: 60)
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = false
//    DestinationPage(title: "収入・支出", isPresented: $isPresented, isLastPage: false) {
    IncConsSecListPage(isPresetntedIncConsSec: $isPresented)
//    }
}

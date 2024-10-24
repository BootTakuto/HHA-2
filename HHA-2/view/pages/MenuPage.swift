//
//  MenuPage.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/12.
//

import SwiftUI

struct MenuPage: View {
    @AppStorage("ACCENT_COLOR") var accentColorHex: String = "FECB3E"
    @Binding var accentColor: Color
    @Binding var accentTextColor: Color
    @State var selectAccentColorHex = "FFFFFF"
    @State var isSheetShow = false
    @State var isInnerHeaderShow = true
    var body: some View {
        GeometryReader { geom in
            VStack {
                AccentColor()
                ScrollView {

                }
            }.floatingSheet(isPresented: $isSheetShow) {
                SelectAccentColorPopUp()
                    .presentationDetents([.fraction(0.999)])
                    .padding(.horizontal, 10)
            }
        }
    }
    
    @ViewBuilder
    func AccentColor() -> some View {
        InnerHeader(isShow: $isInnerHeaderShow, isAbleShrink: false, hiddenOffset: 0, height: 50) {
            HStack {
                Footnote(text: "アクセントカラー")
                Image(systemName: "paintpalette")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                Spacer()
                Circle()
                    .stroke(lineWidth: 2)
                    .fill(.gray)
                    .frame(width: 30, height: 30)
                    .overlay {
                        Circle()
                            .fill(accentColor)
                            .shadow(color: .changeableShadow, radius: 2)
                            .padding(4)
                    }.onTapGesture {
                        self.isSheetShow = true
                    }
            }.padding(.horizontal, 20)
        }
    }
    
    @ViewBuilder
    func SelectAccentColorPopUp() -> some View {
        Card {
            VStack(spacing: 0) {
                HStack {
                    Footnote(text: "アクセントカラーの選択")
                    Spacer()
                    Circle()
                        .stroke(lineWidth: 2)
                        .fill(.gray)
                        .frame(width: 30, height: 30)
                        .overlay {
                            Circle()
                                .fill(CommonViewModel.getColorFromHex(hex: selectAccentColorHex))
                                .shadow(color: .changeableShadow, radius: 2)
                                .padding(4)
                        }
                }.padding(.bottom, 10)
                Palette(hex: $selectAccentColorHex)
                    .padding(.bottom, 10)
                RegistButton(text: "登録") {
                    withAnimation {
                        self.accentColorHex = selectAccentColorHex
                        self.accentColor = CommonViewModel.getAccentColor()
                        self.accentTextColor = CommonViewModel.getTextColor()
                    }
                    self.isSheetShow = false
                }.frame(height: 40)
                    .padding(.bottom, 5)
                CancelButton(text: "閉じる"){
                    self.isSheetShow = false
                }.frame(height: 40)
            }.padding(10)
        }.frame(height: 420)
    }
}

#Preview {
    ContentView()
}

//#Preview {
//    MenuPage()
//}

//
//  DeleteAlertPopUpCard.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/12/16.
//

import SwiftUI

struct AlertPopUpCard: View {
    @Binding var isPresented: Bool
    var message: String
    let accentColor = CommonViewModel.getAccentColor()
    let accentTextColor = CommonViewModel.getTextColor()
    var action: () -> ()
    var body: some View {
        Card(shadowColor: .black.opacity(0.25), shadowRadius: 50) {
            VStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .foregroundStyle(.yellow)
                    .background {
                        Image(systemName: "triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.black)
                    }
                Text(message)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                HStack {
                    RoundedButton(text: "キャンセル",
                                  textColor: .changeableText,
                                  isDispStroke: true, isDispShadow: false) {
                        self.isPresented = false
                    }.frame(width: 120, height: 30)
                    RoundedButton(color: accentColor,
                                  text: "はい",
                                  textColor: accentTextColor,
                                  isDispShadow: false) {
                        action()
                    }.frame(width: 120, height: 30)
                }
            }.padding(.horizontal, 20)
                .padding(.vertical, 10)
        }.frame(width: 300, height: 150)
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = false
    AlertPopUpCard(isPresented: $isPresented, message: "この残高を削除します。よろしいですか。\n※この残高に連携された収支情報などの一切が削除されます。") {
        print("preveiw test")
    }
}

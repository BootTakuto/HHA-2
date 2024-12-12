//
//  RegitPopUpCard.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/12/11.
//

import SwiftUI

struct RegistPopUpCard: View {
    @Binding var isSucceed: Bool
    var body: some View {
        Card(shadowColor: .black.opacity(0.25), shadowRadius: 50) {
            VStack {
                if isSucceed {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.green)
                    Text("登録が完了しました。")
                        .foregroundStyle(.changeableText)
                } else {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.red)
                    Text("登録に失敗しました。")
                        .foregroundStyle(.changeableText)
                }
               
            }
        }.frame(width: 200, height: 200)
    }
}

#Preview {
    @Previewable @State var isSucceed = false
    RegistPopUpCard(isSucceed: $isSucceed)
}

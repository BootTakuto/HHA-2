//
//  ResizColableImage.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/12/19.
//

import SwiftUI

struct ResizColableImage: View {
    var imageNm: String
    init(_ imageNm: String) {
        self.imageNm = imageNm
    }
    var body: some View {
        Image(imageNm)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(.gray)
    }
}

#Preview {
    ResizColableImage("happy.person")
}

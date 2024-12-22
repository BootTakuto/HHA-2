//
//  ResizColableImage.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/12/19.
//

import SwiftUI

struct ResizColableImage: View {
    var imageNm: String
    var color: Color
    init(_ imageNm: String) {
        self.imageNm = imageNm
        self.color = Color.gray
    }
    init(_ imageNm: String, color: Color) {
        self.imageNm = imageNm
        self.color = color
    }
    var body: some View {
        Image(imageNm)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(color)
    }
}

#Preview {
    ResizColableImage("happy.person")
}

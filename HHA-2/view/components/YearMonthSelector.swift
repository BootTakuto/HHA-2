//
//  DateSelector.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/14.
//

import SwiftUI

struct YearMonthSelector: View {
    @Binding var targetDate: Date
    @State var isSheetPresented = false
    var selectComponents: DateSelectComponents = .month
    let commonVm = CommonViewModel()
    var body: some View {
        RoundedRectangle(cornerRadius: .infinity)
            .fill(Color(uiColor: .systemGray6))
            .frame(height: 35)
            .overlay {
                HStack {
                    Button(action: {
                        self.targetDate = commonVm.getAddingDate(targetDate: targetDate, adding: -1)
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    Text(commonVm.getFormatDate(format: "yyyy年MM月", date: targetDate))
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            self.isSheetPresented.toggle()
                        }
                    Button(action: {
                        self.targetDate = commonVm.getAddingDate(targetDate: targetDate, adding: 1)
                    }) {
                        Image(systemName: "chevron.right")
                    }
                }.font(.footnote)
                    .foregroundStyle(.changeableText)
            }.frame(width: 200)
            .floatingSheet(isPresented: $isSheetPresented) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        
                }.presentationDetents([.height(330)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(330)))
            }
    }
    
    enum DateSelectComponents {
        case month
        case year
    }
}

//#Preview {
//    @Previewable @State var date = Date()
//    return DateSelector(selectDate: $date)
//}

#Preview {
    ContentView()
}

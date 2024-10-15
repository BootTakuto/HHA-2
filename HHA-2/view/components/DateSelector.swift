//
//  DateSelector.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/26.
//

import SwiftUI

struct DateSelector: View {
    @Binding var selectDate: Date
    @State var isShowSheet = false
    var height: CGFloat = 50
    var isDispStroke = true
    var isDispShadow = true
    let commonVm = CommonViewModel()
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.changeable)
            .overlay {
                if isDispStroke {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 0.5)
                        .fill(.changeableStroke)
                }
            }.shadow(color: isDispShadow ? .changeableShadow.opacity(0.5) : .clear, radius: 10)
            .frame(height: height)
            .overlay {
                Text(commonVm.getFormatDate(format: "yyyy年M月d日", date: selectDate))
            }
            .onTapGesture {
                self.isShowSheet.toggle()
            }
            .floatingSheet(isPresented: $isShowSheet) {
                DatePickerRect()
                    .presentationDetents([.height(310)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(310)))
            }
    }
    
    @ViewBuilder
    func DatePickerRect() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.changeable)
                .padding(.top, 10)
                .shadow(color: .changeableShadow, radius: 5)
            VStack(spacing: 0) {
//                Image(systemName: "chevron.compact.down")
//                    .frame(maxWidth: .infinity)
//                    .contentShape(Rectangle())
//                    .onTapGesture {
//                        self.isShowSheet = false
//                    }
                DatePicker("", selection: $selectDate, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .frame(width: 320, height: 250)
                    .offset(y: 35)
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                    
            }
        }.ignoresSafeArea()
    }
}

#Preview {
    @Previewable @State var selectDate = Date()
    DateSelector(selectDate: $selectDate)
}

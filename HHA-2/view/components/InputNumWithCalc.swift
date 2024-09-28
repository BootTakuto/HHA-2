//
//  InputNumWithCalc.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/22.
//

import SwiftUI

struct InputNumWithCalc: View {
    var accentColor: Color
    @Binding var inputNum: String
    @State var isSheetShow = false
    @State var isPushedSymbolButton = false
    @State var pushedSymbolBehavior: CalculatorBehavior = .none
    @State var calcTargetNum = ""
    var font: Font = .body
    var height: CGFloat = 50
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color(uiColor: .systemGray5))
                .onTapGesture {
                    self.isSheetShow.toggle()
                }
            VStack {
                Text("¥\(inputNum)")
                    .font(font)
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }.frame(height: height)
            .floatingSheet(isPresented: $isSheetShow) {
                Calculator()
                    .presentationDetents([.height(300)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(300)))
            }
    }
    
    @ViewBuilder
    func Calculator() -> some View {
        GeometryReader {
            let safeAreaInsets = $0.safeAreaInsets
            ZStack {
                let buttons = [CalculatorButton(text: "C", behavior: .clearNum),
                               CalculatorButton(text: "+/-", behavior: .changePlusOrMunus),
                               CalculatorButton(text: "del", behavior: .delete),
                               CalculatorButton(text: "÷", behavior: .division),
                               CalculatorButton(text: "7", behavior: .seven),
                               CalculatorButton(text: "8", behavior: .eight),
                               CalculatorButton(text: "9", behavior: .nine),
                               CalculatorButton(text: "×", behavior: .multiplication),
                               CalculatorButton(text: "4", behavior: .four),
                               CalculatorButton(text: "5", behavior: .five),
                               CalculatorButton(text: "6", behavior: .six),
                               CalculatorButton(text: "-", behavior: .subtraction),
                               CalculatorButton(text: "1", behavior: .one),
                               CalculatorButton(text: "2", behavior: .two),
                               CalculatorButton(text: "3", behavior: .three),
                               CalculatorButton(text: "+", behavior: .addition),
                               CalculatorButton(text: "0", behavior: .zero),
                               CalculatorButton(text: "00", behavior: .wZero),
                               CalculatorButton(text: "・", behavior: .dot),
                               CalculatorButton(text: pushedSymbolBehavior == .equal ? "確定" : "=", behavior: .equal)]
                let buttonColors = [.changeableCalcSymbol, .changeableCalcSymbol, .changeableCalcSymbol, .changeableCalcSymbol,
                                    .changeable, .changeable, .changeable, .changeableCalcSymbol,
                                    .changeable, .changeable, .changeable, .changeableCalcSymbol,
                                    .changeable, .changeable, .changeable, .changeableCalcSymbol,
                                    .changeable, .changeable, .changeable, accentColor]
                UnevenRoundedRectangle(topLeadingRadius: 10, topTrailingRadius: 10)
                    .fill(.changeable)
                    .padding(.top, 10)
                    .shadow(color: .changeableShadow, radius: 5)
                VStack(spacing: 0) {
//                    Image(systemName: "chevron.compact.down")
//                        .padding(.bottom, 5)
//                        .frame(maxWidth: .infinity)
//                        .contentShape(Rectangle())
//                        .onTapGesture {
//                            self.isSheetShow = false
//                        }
                    ForEach(0 ..< 5, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0 ..< 4, id: \.self) { col in
                                let index = col + (row * 4)
                                let button = buttons[index]
                                let buttonColor = pushedSymbolBehavior == button.behavior ? accentColor.opacity(0.25) : buttonColors[index]
                                ZStack {
                                    RoundedButton(radius: 5, color: buttonColor, text: button.text) {
                                        calcBehavior(buttonText: button.text, calcBehavior: button.behavior)
                                    }.padding(5)
                                }
                            }
                        }
                    }
                    Spacer()
                        .frame(height: safeAreaInsets.bottom)
                }.padding(.horizontal, 10)
                    .padding(.top, 20)
            }.ignoresSafeArea()
        }
    }
    
    func calcBehavior(buttonText: String, calcBehavior: CalculatorBehavior) {
        switch calcBehavior {
        case .clearNum:
            self.inputNum = "0"
            changeCalcBehavior(isPushedSymbol: false, calcBehavior: .none)
        case .changePlusOrMunus:
            if inputNum != "0" {
                if inputNum.first != "-" {
                    self.inputNum = "-" + inputNum
                } else {
                    self.inputNum = String(inputNum.dropFirst())
                }
            }
        case .delete:
            if inputNum != "0" {
                if (inputNum.first != "-" && inputNum.count > 1) || (inputNum.first == "-" && inputNum.count > 2) {
                    self.inputNum = String(inputNum.dropLast())
                } else {
                    self.inputNum = "0"
                }
            }
        case .division, .multiplication, .subtraction, .addition:
            if !isPushedSymbolButton {
                if pushedSymbolBehavior != .none {
                    calculator()
                }
                self.calcTargetNum = inputNum
                changeCalcBehavior(isPushedSymbol: true, calcBehavior: calcBehavior)
            } else {
                changeCalcBehavior(isPushedSymbol: true, calcBehavior: calcBehavior)
            }
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
            if inputNum == "0" || isPushedSymbolButton {
                self.inputNum = buttonText
            } else {
                self.inputNum = inputNum + buttonText
            }
            if isPushedSymbolButton {
                self.isPushedSymbolButton = false
            }
        case .wZero:
            if inputNum != "0" {
                self.inputNum = inputNum + buttonText
            }
        case .dot:
            self.inputNum = inputNum + "."
        case .equal:
            calculator()
            changeCalcBehavior(isPushedSymbol: false, calcBehavior: .none)
        case .none:
            break
        }
    }
    
    func changeCalcBehavior(isPushedSymbol: Bool, calcBehavior: CalculatorBehavior) {
        self.isPushedSymbolButton = isPushedSymbol
        self.pushedSymbolBehavior = calcBehavior
    }
    
    func calculator() {
        let firstNum = NSDecimalNumber(string: calcTargetNum)
        let secondNum = NSDecimalNumber(string: inputNum)
        if pushedSymbolBehavior == .addition {
//            self.inputNum = String(calcTargetNum + Double(inputNum)!)
            self.inputNum = String(describing: firstNum.adding(secondNum))
        } else if pushedSymbolBehavior == .subtraction {
//            self.inputNum = String(calcTargetNum - Double(inputNum)!)
            self.inputNum = String(describing: firstNum.subtracting(secondNum))
        } else if pushedSymbolBehavior == .multiplication {
//            self.inputNum = String(calcTargetNum * Double(inputNum)!)
            self.inputNum = String(describing: firstNum.multiplying(by: secondNum))
        } else if pushedSymbolBehavior == .division {
//            self.inputNum = String(calcTargetNum / Double(inputNum)!)
            if secondNum != 0 {
                self.inputNum = String(describing: firstNum.dividing(by: secondNum))
            } else {
                self.inputNum = "エラー"
            }
        }
        
        if inputNum.count >= 3 && inputNum.suffix(2) == ".0" {
            self.inputNum = String(inputNum.dropLast(2))
        }
    }
    
    enum CalculatorBehavior {
        case clearNum
        case changePlusOrMunus
        case delete
        case division
        case multiplication
        case subtraction
        case addition
        case equal
        case one
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
        case zero
        case wZero
        case dot
        case none
    }
    
    struct CalculatorButton {
        var text: String
        var behavior: CalculatorBehavior
        init(text: String, behavior: CalculatorBehavior) {
            self.text = text
            self.behavior = behavior
        }
    }
}

#Preview {
    @Previewable @State var inputNum = "0"
    InputNumWithCalc(accentColor: .orange, inputNum: $inputNum)
}

//
//  ContentView.swift
//  HHA-2
//
//  Created by 青木択斗 on 2024/09/12.
//
import SwiftUI

struct ContentView: View {
    @State var accentColor = CommonViewModel.getAccentColor()
    @State var accentTextColor = CommonViewModel.getTextColor()
    @State var selectedIndex = 0
    let tabTitles = [SlideableTabTitle(icon: "banknote", title: "資産・負債", rectTLRadi: 0, rectTTRadi: 0, isSystemName: true),
                     SlideableTabTitle(icon: "piggy.bank.no.coins", title: "家計", rectTLRadi: 10, rectTTRadi: 0, isSystemName: false),
                     SlideableTabTitle(icon: "gearshape", title: "その他", rectTLRadi: 10, rectTTRadi: 0, isSystemName: true)]
    var body: some View {
        NavigationStack {
            GeometryReader { geom in
                let safeAreaInsets = geom.safeAreaInsets
                ZStack {
                    accentColor
                    SlideableTab(selectIndex: $selectedIndex, titles: tabTitles)
                        .padding(.top, safeAreaInsets.top + 10)
                    VStack {
                        Spacer().frame(height: safeAreaInsets.top + 10 + 30 + 20)
                        switch selectedIndex {
                        case 0:
                            BalanceParentView(accentColor: accentColor,
                                              accentTextColor: accentTextColor,
                                              safeAreaInsets: safeAreaInsets)
                        case 1:
                            HouseHoldParentView(accentColor: accentColor, accentTextColor: accentTextColor)
                        case 2:
                            MenuPage(accentColor: $accentColor, accentTextColor: $accentTextColor)
                        default:
                            BalanceParentView(accentColor: accentColor,
                                              accentTextColor: accentTextColor,
                                              safeAreaInsets: safeAreaInsets)
                        }
                    }
                }.ignoresSafeArea()
            }
        }.onAppear {
            let realm = CommonViewModel().realm
            print(realm.configuration.fileURL!)
        }
    }
}

#Preview {
    ContentView()
}

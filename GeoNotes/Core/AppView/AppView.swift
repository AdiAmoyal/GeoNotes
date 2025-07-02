//
//  AppView.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 02/07/2025.
//

import SwiftUI

struct AppView: View {
    
    @AppStorage("showTabbarView") var showTabBar: Bool = false
    
    var body: some View {
        ZStack {
            if showTabBar {
                TabBarView()
                    .transition(.move(edge: .trailing))
            } else {
                LoginView()
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.smooth, value: showTabBar)
        .onTapGesture {
            showTabBar.toggle()
        }
    }
}

#Preview("AppView - Tabbar") {
    AppView(showTabBar: true)
}

#Preview("AppView - Login") {
    AppView(showTabBar: false)
}

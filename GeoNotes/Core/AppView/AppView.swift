//
//  AppView.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 02/07/2025.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    
    let store: StoreOf<AppStateFeature>
    
    var body: some View {
        ZStack {
            WithViewStore(self.store, observe: \.showTabBar) { viewStore in
                if viewStore.state {
                    TabBarView(notesStore: store.scope(state: \.logout, action: \.logout))
                        .transition(.move(edge: .trailing))
                } else {
                    SignupView(
                        store: store.scope(state: \.signup, action: \.signup)
                    )
                    .transition(.move(edge: .leading))
                }
            }
        }
        .animation(.smooth, value: store.showTabBar)
    }
}

#Preview("AppView - Tabbar") {
    AppView(
        store: Store(
            initialState: AppStateFeature.State(showTabBar: true),
            reducer: {
                AppStateFeature()
            }
        )
    )
}

#Preview("AppView - Login") {
    AppView(
        store: Store(
            initialState: AppStateFeature.State(showTabBar: false),
            reducer: {
                AppStateFeature()
            }
        )
    )
}

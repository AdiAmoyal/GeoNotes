//
//  TabBarView.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 02/07/2025.
//

import SwiftUI
import ComposableArchitecture

struct TabBarView: View {
    
    let notesStore: StoreOf<NotesFeature>
    
    var body: some View {
        TabView {
            NotesView(store: notesStore)
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
            
            MapView()
                .tabItem {
                    Label("Notes", systemImage: "map")
                }
        }
    }
}

#Preview {
    TabBarView(
        notesStore: Store(
            initialState: NotesFeature.State(),
            reducer: {
                NotesFeature()
            }
        )
    )
}

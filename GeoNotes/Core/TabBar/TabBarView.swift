//
//  TabBarView.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 02/07/2025.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            NotesView()
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
    TabBarView()
}

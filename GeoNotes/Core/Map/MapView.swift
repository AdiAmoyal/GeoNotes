//
//  MapView.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 02/07/2025.
//

import SwiftUI

struct MapView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                Text("Map view")
            }
        }
    }
}

#Preview {
    MapView()
}

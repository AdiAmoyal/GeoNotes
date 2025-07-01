//
//  ContentView.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 01/07/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Hello, world!")
                .foregroundStyle(Color.accentColor)
            
            Text("Hello, world!")
                .foregroundStyle(Color.secondary)
            
            Text("Hello, world!")
                .foregroundStyle(Color.background)
            
            Text("Hello, world!")
                .foregroundStyle(Color.text)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

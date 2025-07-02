//
//  NotesView.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 02/07/2025.
//

import SwiftUI

struct NotesView: View {
    
    @State var userName: String = "Adi"
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                VStack {
                    header
                    
                    Spacer()
                }
            }
        }
    }
    
    private var header: some View {
        HStack {
            Text("Welcome, \(userName)!")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(Color.text)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                logoutButtonPressed()
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.forward")
                    .font(.headline)
            }
        }
        .padding(24)
    }
    
    private func logoutButtonPressed() {
        
    }
}

#Preview {
    NotesView()
}

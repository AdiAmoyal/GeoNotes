//
//  NotePreviewView.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 03/07/2025.
//

import SwiftUI

struct NotePreviewView: View {
    
    let note: NoteModel
    let onNextButtonPressed: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            titleSection
            nextButton
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
        )
        .cornerRadius(10)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(note.title)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(note.body)
                .font(.subheadline)
                .lineLimit(2)
        }
        .foregroundStyle(Color.text)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var nextButton: some View {
        Button(action: onNextButtonPressed) {
            Text("Next")
                .font(.headline)
                .frame(width: 125, height: 35)
        }
        .buttonStyle(.bordered)
    }
}

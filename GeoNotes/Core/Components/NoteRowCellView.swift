//
//  NoteRowCellView.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 03/07/2025.
//

import SwiftUI

struct NoteRowCellView: View {
    
    var note: NoteModel = NoteModel.mock
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                title
                bodySection
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            dateCreation
        }
        .foregroundStyle(Color.text)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.secondary.opacity(0.1))
        )
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
    
    private var title: some View {
        Text(note.title)
            .font(.headline)
            .foregroundStyle(.primary)
    }
    
    private var bodySection: some View {
        Text(note.body)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .lineLimit(1)
    }
    
    private var dateCreation: some View {
        HStack(spacing: 4) {
            Image(systemName: "calendar")
                .font(.caption)
            Text(note.creationDate.shortFormatted)
                .font(.caption)
        }
        .foregroundStyle(.secondary)
        .padding(.leading, 8)
    }
}

extension Date {
    var shortFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}

#Preview {
    NoteRowCellView()
        .padding()
}

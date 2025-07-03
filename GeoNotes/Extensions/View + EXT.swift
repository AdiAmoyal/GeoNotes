//
//  View + EXT.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 03/07/2025.
//
import SwiftUI

extension View {
    
    func customTextField(type: String, focusColor: Color) -> some View {
        self
            .padding()
            .frame(height: 50)
        //            .font(.headline)
            .foregroundStyle(Color.text)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(focusColor, lineWidth: 2)
            )
            .overlay(alignment: .topLeading) {
                Text(type)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(focusColor)
                    .padding(.horizontal, 5)
                    .background(Color.background)
                    .offset(x: 15, y: -10)
            }
    }
    
    func tappableBackground() -> some View {
        background(Color.black.opacity(0.001))
    }
    
    func removeListRowFormatting() -> some View {
        self
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
    
    func callToActionButton() -> some View {
        self
            .font(.headline)
            .foregroundStyle(Color.text)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
}

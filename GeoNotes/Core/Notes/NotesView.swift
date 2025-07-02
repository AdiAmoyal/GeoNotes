//
//  NotesView.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 02/07/2025.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct NotesFeature {
    
    @ObservableState
    struct State {
        var userName: String = "Adi"
    }
    
    enum Action {
        case logoutButtonPressed
        case logoutSucceeded
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .logoutButtonPressed:
                // TODO: Add logic to signout
                return .send(.logoutSucceeded)
            case .logoutSucceeded:
                return .none
            }
        }
    }
}

struct NotesView: View {
    
    let store: StoreOf<NotesFeature>
    
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
            Text("Welcome, \(store.userName)!")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(Color.text)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                store.send(.logoutButtonPressed)
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.forward")
                    .font(.headline)
            }
        }
        .padding(24)
    }
}

#Preview {
    NotesView(
        store: Store(
            initialState: NotesFeature.State(),
            reducer: {
                NotesFeature()
            }
        )
    )
}

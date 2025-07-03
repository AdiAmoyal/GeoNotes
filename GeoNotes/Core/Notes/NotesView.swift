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
        var notes: [NoteModel] = NoteModel.mocks
        var isLoading: Bool = false
        var showAddNewNoteSheet: Bool = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case logoutButtonPressed
        case logoutSucceeded
        case showAddNewNoteButtonPressed
        case onDeleteNotePressed(IndexSet)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .logoutButtonPressed:
                // TODO: Add logic to signout
                return .send(.logoutSucceeded)
            case .logoutSucceeded:
                return .none
            case .showAddNewNoteButtonPressed:
                state.showAddNewNoteSheet = true
                return .none
            case .onDeleteNotePressed(let indexSet):
                guard let index = indexSet.first else { return .none }
                state.notes.remove(at: index)
                return .none
            }
        }
    }
}

struct NotesView: View {
    
    @Bindable var store: StoreOf<NotesFeature>
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    header
                    notesList
                        .overlay(alignment: .bottomTrailing) {
                            addNewNoteButton
                                .padding(16)
                                .padding(.horizontal, 8)
                                .padding(.bottom, 22)
                        }
                }
                .padding()
                .sheet(isPresented: $store.showAddNewNoteSheet) {
                    Text("Add new note")
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
    }
    
    private var notesList: some View {
        List {
            if store.notes.isEmpty {
                Group {
                    if store.isLoading {
                        ProgressView()
                    } else {
                        Text("Click + to add new note")
                    }
                }
                .padding(50)
                .frame(maxWidth: .infinity)
                .font(.body)
                .foregroundStyle(Color.secondary)
                .removeListRowFormatting()
            } else {
                ForEach(store.notes) { note in
                    NoteRowCellView(note: note)
                        .padding(.bottom, 8)
                        .removeListRowFormatting()
                        .redacted(reason: store.isLoading ? .placeholder : [])
                }
                .onDelete { indexSet in
                    store.send(.onDeleteNotePressed(indexSet))
                }
            }
        }
        .listStyle(PlainListStyle())
        .scrollIndicators(.hidden)
    }
    
    private var addNewNoteButton: some View {
        Button {
            store.send(.showAddNewNoteButtonPressed)
        } label: {
            Image(systemName: "plus")
                .font(.title2)
                .fontWeight(.medium)
                .padding(16)
                .foregroundStyle(.text)
                .background(.accent)
                .clipShape(Circle())
        }
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

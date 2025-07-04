//
//  NotesFeature.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 03/07/2025.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct NotesFeature {
    
    @ObservableState
    struct State {
        var currentUser: UserModel?
        var notes: [NoteModel] = []
        var isLoading: Bool = false
        @Presents var addNewNoteSheet: AddNewNoteFeature.State?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case logoutButtonPressed
        case logoutSucceeded
        case addNewNoteButtonPressed
        case addNewNoteSheet(PresentationAction<AddNewNoteFeature.Action>)
        case onDeleteNotePressed(IndexSet)
        case userLoaded(UserModel)
        case notesLoaded([NoteModel])
    }
    
    @Dependency(\.firebaseAuthService) var authService
    @Dependency(\.firebaseUserService) var userService
    @Dependency(\.firebaseNotesService) var noteService

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    if let user = authService.currentUser() {
                        do {
                            let currentUser = try await userService.getUser(user.uid)
                            print("2222")
                            let firebaseNotes = try await noteService.fetchNotes(currentUser.userId)
                            let notes = firebaseNotes.map { NoteModel(note: $0) }
                            await send(.userLoaded(currentUser))
                            await send(.notesLoaded(notes))
                        } catch {
                            print("Failed to get current user: \(error)")
                        }
                    }
                }
            case .logoutButtonPressed:
                do {
                    try authService.signOut()
                } catch {
                    print("Sign out failed: \(error)")
                }
                return .send(.logoutSucceeded)
            case .logoutSucceeded:
                return .none
            case .addNewNoteButtonPressed:
                state.addNewNoteSheet = AddNewNoteFeature.State()
                return .none
            case .addNewNoteSheet(.presented(.delegate(.save(let note)))):
                state.notes.insert(note, at: 0)
                return .run { [currentUser = state.currentUser] send in
                    if let user = currentUser {
                        do {
                            try await noteService.addNote(user.userId, note)
                        } catch {
                            print("Failed to save note: \(error)")
                        }
                    }
                }
            case .addNewNoteSheet:
                return .none
            case .onDeleteNotePressed(let indexSet):
                guard let index = indexSet.first else { return .none }
                state.notes.remove(at: index)
                return .run { [currentUser = state.currentUser, notes = state.notes] send in
                    if let user = currentUser,
                       let index = indexSet.first {
                        do {
                            try await noteService.deleteNote(user.userId, notes[index].id)
                        } catch {
                            print("Failed to delete note: \(error)")
                        }
                    }
                }
            case .userLoaded(let user):
                state.currentUser = user
                return .none
            case .notesLoaded(let notes):
                state.notes = notes
                state.isLoading = false
                return .none
            }
        }
        .ifLet(\.$addNewNoteSheet, action: \.addNewNoteSheet) {
            AddNewNoteFeature()
        }
    }
}

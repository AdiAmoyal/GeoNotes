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
        var userName: String = "Adi"
        var notes: [NoteModel] = NoteModel.mocks
        var isLoading: Bool = false
        @Presents var addNewNoteSheet: AddNewNoteFeature.State?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case logoutButtonPressed
        case logoutSucceeded
        case addNewNoteButtonPressed
        case addNewNoteSheet(PresentationAction<AddNewNoteFeature.Action>)
        case onDeleteNotePressed(IndexSet)
        case onAppear
    }
    
    @Dependency(\.firebaseAuthService) var authService
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
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
            case .addNewNoteSheet(.presented(.delegate(.save))):
                return .none
            case .addNewNoteSheet:
                return .none
            case .onDeleteNotePressed(let indexSet):
                guard let index = indexSet.first else { return .none }
                state.notes.remove(at: index)
                return .none
            case .onAppear:
//                if let user = authService.currentUser() {
//                    print("User is already signed in: \(user.uid)")
//                    state.showTabBar = true
//                } else {
//                    state.showTabBar = false
//                }
                return .none
            }
        }
        .ifLet(\.$addNewNoteSheet, action: \.addNewNoteSheet) {
            AddNewNoteFeature()
        }
    }
}

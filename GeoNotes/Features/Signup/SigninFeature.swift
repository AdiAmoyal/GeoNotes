//
//  SigninFeature.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 04/07/2025.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SigninFeature {
    
    @ObservableState
    struct State {
        var email: String = ""
        var password: String = ""
        var showPassword: Bool = false
        var focusField: Field? = nil
        var isLoading: Bool = false
    }
    
    enum Field: Hashable {
        case name, email, password
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case delegate(Delegate)
        case showPasswordButtonPressed
        case signinButtonPressed
        case signInSucceeded
        case signInFailed(String)
        
        enum Delegate: Equatable {
            case signInSucceeded
            case signInFailed(String)
        }
    }
    
    @Dependency(\.firebaseAuthService) var auth
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .delegate:
                return .none
            case .showPasswordButtonPressed:
                state.showPassword.toggle()
                return .none
            case .signinButtonPressed:
                state.isLoading = true
                return .run { [email = state.email, password = state.password] send in
                    do {
                        guard !email.isEmpty, !password.isEmpty else { return }
                        let user = try await auth.signIn(email, password)
                        print("User signed in: \(user.uid)")
                        await send(.signInSucceeded)
                    } catch {
                        print("Signin error: \(error.localizedDescription)")
                        await send(.signInFailed("Signin error: \(error.localizedDescription)"))
                    }
                }
            case .signInSucceeded:
                state.isLoading = false
                return .run { send in
                    await send(.delegate(.signInSucceeded))
                }
            case .signInFailed(let message):
                state.isLoading = false
                return .run { send in
                    await send(.delegate(.signInFailed(message)))
                }
            }
        }
    }
}

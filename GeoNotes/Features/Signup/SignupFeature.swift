//
//  SignupFeature.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 03/07/2025.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SignupFeature {
    
    @ObservableState
    struct State {
        var name: String = ""
        var email: String = ""
        var password: String = ""
        var showPassword: Bool = false
        var focusField: Field? = nil
        var isLoading: Bool = false
        @Presents var signInSheet: SigninFeature.State?
    }
    
    enum Field: Hashable {
        case name, email, password
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case showPasswordButtonPressed
        case focusChanged(Field?)
        case signupButtonPressed
        case signupSucceeded
        case resetVariables
        case signinButtonPressed
        case signInSheet(PresentationAction<SigninFeature.Action>)
    }
    
    @Dependency(\.firebaseAuthService) var auth
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .showPasswordButtonPressed:
                state.showPassword.toggle()
                return .none
            case .focusChanged(let field):
                state.focusField = field
                return .none
            case .signupButtonPressed:
                state.isLoading = true
                return .run { [email = state.email, password = state.password] send in
                    do {
                        guard !email.isEmpty, !password.isEmpty else { return }
                        let user = try await auth.signUp(email, password)
                        print("User signed up: \(user.uid)")
                        await send(.signupSucceeded)
                        await send(.resetVariables)
                    } catch {
                        print("Signup error: \(error.localizedDescription)")
                    }
                }
            case .signupSucceeded:
                state.isLoading = false
                return .none
            case .resetVariables:
                state.email = ""
                state.password = ""
                return .none
            case .signinButtonPressed:
                state.signInSheet = SigninFeature.State()
                return .none
            case .signInSheet(.presented(.delegate(.signInSucceeded))):
                state.signInSheet = nil
                return .send(.signupSucceeded)
            case .signInSheet:
                return .none
            }
        }
        .ifLet(\.$signInSheet, action: \.signInSheet) {
            SigninFeature()
        }
    }
}

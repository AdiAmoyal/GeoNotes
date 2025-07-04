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
        
        var errorMessage: String?
        
        @Presents var signInSheet: SigninFeature.State?
    }
    
    enum Field: Hashable {
        case name, email, password
    }
    
    enum Alert {
        case inputsAreInvalid
        case signupFailed(Error)
        
        var description: String {
            switch self {
            case .inputsAreInvalid:
                return "Inputs are invalid"
            case .signupFailed(error: let error):
                return "Signup error: \(error.localizedDescription)"
            }
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case showPasswordButtonPressed
        case focusChanged(Field?)
        case signupButtonPressed
        case signupSucceeded
        case signupFailed
        case resetVariables
        case signinButtonPressed
        case signInSheet(PresentationAction<SigninFeature.Action>)
        case errorReceived(String?)
    }
    
    @Dependency(\.firebaseAuthService) var auth
    @Dependency(\.firebaseUserService) var userService
    
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
                return .run { [email = state.email, password = state.password, name = state.name] send in
                    do {
                        guard !email.isEmpty,
                              !password.isEmpty,
                              !name.isEmpty,
                              password.count >= 6 else {
                            await send(.errorReceived(Alert.inputsAreInvalid.description))
                            return
                        }
                        let authUser = try await auth.signUp(email, password)
                        let user = UserModel(
                            userId: authUser.uid,
                            dateCreated: authUser.creationDate ?? .now,
                            email: email,
                            name: name,
                            notes: []
                        )
                        try await userService.saveUser(user)
                        print("User signed up: \(authUser.uid)")
                        await send(.signupSucceeded)
                        await send(.resetVariables)
                    } catch {
                        print("Signup error: \(error.localizedDescription)")
                        await send(.errorReceived(Alert.signupFailed(error).description))
                    }
                }
            case .signupSucceeded:
                state.isLoading = false
                return .none
            case .signupFailed:
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
            case .signInSheet(.presented(.delegate(.signInFailed(let message)))):
                state.signInSheet = nil
                state.errorMessage = message
                return .none
            case .signInSheet:
                return .none
            case .errorReceived(let message):
                state.errorMessage = message
                state.isLoading = false
                return .none
            }
        }
        .ifLet(\.$signInSheet, action: \.signInSheet) {
            SigninFeature()
        }
    }
}

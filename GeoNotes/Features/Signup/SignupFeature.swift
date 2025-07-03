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
    }
    
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
                // TODO: Add logic to signup
                return .send(.signupSucceeded)
            case .signupSucceeded:
                return .none
            }
        }
    }
}

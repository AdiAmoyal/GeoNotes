//
//  AppStateFeature.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 02/07/2025.
//
import ComposableArchitecture
import SwiftUI

@Reducer
struct AppStateFeature {
    
    @ObservableState
    struct State {
        
        var showTabBar: Bool {
            didSet {
                UserDefaults.showTabBarView = showTabBar
            }
        }
        
        var signup = SignupFeature.State()
        var logout = NotesFeature.State()
        var signin = SigninFeature.State()
        
        init(showTabBar: Bool = UserDefaults.showTabBarView) {
            self.showTabBar = showTabBar
        }
    }
    
    enum Action {
        case updateViewState(Bool)
        case signup(SignupFeature.Action)
        case logout(NotesFeature.Action)
        case signin(SigninFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.signup, action: \.signup) {
            SignupFeature()
        }
        
        Scope(state: \.logout, action: \.logout) {
            NotesFeature()
        }
        
        Scope(state: \.signin, action: \.signin) {
            SigninFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .updateViewState(let showTabbar):
                state.showTabBar = showTabbar
                return .none
            case .signup(.signupSucceeded):
                state.showTabBar = true
                return .none
            case .logout(.logoutSucceeded):
                state.showTabBar = false
                return .none
            case .signin(.signInSucceeded):
                state.showTabBar = true
                return .none
            case .signup:
                return .none
            case .logout:
                return .none
            case .signin:
                return .none
            }
        }
    }
}

//
//  SignInView.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 03/07/2025.
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
        
        enum Delegate: Equatable {
            case signInSucceeded
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
                    }
                }
            case .signInSucceeded:
                state.isLoading = false
                return .run { send in
                    await send(.delegate(.signInSucceeded))
                }
            }
            
        }
    }
}

struct SignInView: View {
    
    @Bindable var store: StoreOf<SigninFeature> = Store(initialState: SigninFeature.State(), reducer: {
        SigninFeature()
    })
    @FocusState private var focusedField: SignupFeature.Field?
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack {
                formSection
                Spacer()
                signInButton
            }
            .padding(24)
        }
        
    }
    
    private var formSection: some View  {
        VStack(spacing: 32) {
            TextField("Email", text: $store.email, prompt: Text("Enter your email.."))
                .autocapitalization(.none)
                .customTextField(type: "Email", focusColor: focusedField == .email ? .text : .secondary)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .password
                }
            
            ZStack {
                if store.showPassword {
                    TextField("Password", text: $store.password, prompt: Text("Enter your password.."))
                } else {
                    SecureField("Password", text: $store.password, prompt: Text("Enter your password.."))
                }
            }
            .customTextField(type: "Password", focusColor: focusedField == .password ? .text : .secondary)
            .focused($focusedField, equals: .password)
            .submitLabel(.go)
            .onSubmit {
                store.send(.signinButtonPressed)
            }
            .overlay(alignment: .trailing) {
                showPasswordButton
            }
        }
    }
    
    private var showPasswordButton: some View {
        Image(systemName: "eye.fill")
            .foregroundStyle(Color.accentColor)
            .padding()
            .tappableBackground()
            .onTapGesture {
                store.send(.showPasswordButtonPressed)
            }
    }
    
    private var signInButton: some View {
        Button {
            store.send(.signinButtonPressed)
        } label: {
            ZStack {
                if store.isLoading {
                    ProgressView()
                } else {
                    Text("SignIn")
                }
            }
            .callToActionButton()
        }
    }
}

#Preview {
    SignInView()
}


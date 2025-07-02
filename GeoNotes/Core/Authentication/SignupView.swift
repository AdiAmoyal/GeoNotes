//
//  LoginView.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 02/07/2025.
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


struct SignupView: View {
    
    @Bindable var store: StoreOf<SignupFeature>
    @FocusState private var focusedField: SignupFeature.Field?
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack {
                iconSection
                
                signupForm
                    .frame(maxHeight: .infinity)
                
                signupButton
            }
            .padding(22)
        }
    }
    
    private var iconSection: some View {
        VStack(spacing: 0) {
            Image("AppIconInternal")
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 300)
            
            Text("Think it · Note it · Pin it")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.text)
        }
    }
    
    private var signupForm: some View {
        VStack(spacing: 28) {
            TextField("Name", text: $store.name, prompt: Text("Enter your name.."))
                .customTextField(type: "Name", focusColor: focusedField == .name ? Color.text : Color.secondary)
                .focused($focusedField, equals: .name)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .email
                }
            
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
                store.send(.signupButtonPressed)
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
    
    private var signupButton: some View {
        Button {
            store.send(.signupButtonPressed)
        } label: {
            ZStack {
                if store.isLoading {
                    ProgressView()
                } else {
                    Text("Signup")
                }
            }
            .font(.headline)
            .foregroundStyle(Color.text)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    SignupView(
        store: Store(
            initialState: SignupFeature.State(),
            reducer: {
                SignupFeature()
            }
        )
    )
}

//
//  LoginView.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 02/07/2025.
//

import SwiftUI
import ComposableArchitecture

struct SignupView: View {
    
    @Bindable var store: StoreOf<SignupFeature>
    @FocusState private var focusedField: SignupFeature.Field?
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack(spacing: 16) {
                iconSection
                
                signupForm
                    .frame(maxHeight: .infinity)
                
                signupButton
                
                HStack(spacing: 1) {
                    Text("Already have an account? ")
                        .foregroundStyle(Color.text)
                    
                    Button(action: {
                        store.send(.signinButtonPressed)
                    }, label: {
                        Text("SignIn")
                            .foregroundStyle(Color.accent)
                    })
                }
                .font(.headline)
            }
            .padding(22)
            .sheet(
                item: $store.scope(state: \.signInSheet, action: \.signInSheet),
                content: { signInStore in
                    SignInView(store: signInStore)
                        .presentationDetents([.medium])
                }
            )
            .alert("Error", isPresented: .constant(store.errorMessage != nil), actions: {
                Button("OK", role: .cancel) {
                    store.send(.errorReceived(nil))
                }
            }, message: {
                if let message = store.errorMessage {
                    Text(message)
                }
            })
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
            .callToActionButton()
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

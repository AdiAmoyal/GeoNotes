//
//  SignInView.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 03/07/2025.
//

import SwiftUI
import ComposableArchitecture

struct SignInView: View {
    
    @Bindable var store: StoreOf<SigninFeature> = Store(initialState: SigninFeature.State(), reducer: {
        SigninFeature()
    })
    @FocusState private var focusedField: SignupFeature.Field?
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack(spacing: 32) {
                titleSection
                formSection
                    .padding(.top, 8)
                Spacer()
                signInButton
            }
            .padding(24)
        }
        
    }
    
    private var titleSection: some View {
        VStack {
            Text("Good to see you again")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(Color.text)
            
            Text("Your notes missed you")
                .font(.headline)
                .foregroundStyle(Color.secondary)
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


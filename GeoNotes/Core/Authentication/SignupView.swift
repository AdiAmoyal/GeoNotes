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

    }
    
    enum Action {
        case signupButtonPressed
        case signupSucceeded
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
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
    
    let store: StoreOf<SignupFeature>
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Button {
                    store.send(.signupButtonPressed)
                } label: {
                    Text("Signup")
                        .font(.headline)
                        .foregroundStyle(Color.text)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
            }
            .padding(22)
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

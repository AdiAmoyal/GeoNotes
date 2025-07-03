//
//  FirebaseAuthService.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 03/07/2025.
//

import Foundation
import Firebase
import FirebaseAuth
import ComposableArchitecture

@DependencyClient
struct FirebaseAuthService {
    var signUp: @Sendable (_ email: String, _ password: String) async throws -> AuthDataResultModel
    var signIn: @Sendable (_ email: String, _ password: String) async throws -> AuthDataResultModel
    var signOut: @Sendable () throws -> Void
    var currentUser: @Sendable () -> User?
}

extension FirebaseAuthService: DependencyKey {
    static let liveValue = Self(
        signUp: { email, password in
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            return AuthDataResultModel(user: authDataResult.user)
        },
        signIn: { email, password in
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            return AuthDataResultModel(user: authDataResult.user)
        },
        signOut: {
            try Auth.auth().signOut()
        },
        currentUser: {
            if let user = Auth.auth().currentUser {
                return user
            }
            return nil
        }
    )
}

extension DependencyValues {
    var firebaseAuthService: FirebaseAuthService {
        get { self[FirebaseAuthService.self] }
        set { self[FirebaseAuthService.self] = newValue }
    }
}

//
//  FirebaseUserService.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 03/07/2025.
//

import Foundation
import FirebaseFirestore
import ComposableArchitecture

@DependencyClient
struct FirebaseUserService {
    var saveUser: @Sendable (_ user: UserModel) async throws -> Void
    var getUser: @Sendable (_ userId: String) async throws -> UserModel
}

extension FirebaseUserService: DependencyKey {
    static let liveValue = Self(
        saveUser: { user in
            try Firestore.firestore()
                .collection("users")
                .document(user.userId)
                .setData(from: user, merge: true)
        },
        getUser: { userId in
            try await Firestore.firestore()
                .collection("users")
                .document(userId)
                .getDocument(as: UserModel.self)
        }
    )
}

extension DependencyValues {
    var firebaseUserService: FirebaseUserService {
        get { self[FirebaseUserService.self] }
        set { self[FirebaseUserService.self] = newValue }
    }
}

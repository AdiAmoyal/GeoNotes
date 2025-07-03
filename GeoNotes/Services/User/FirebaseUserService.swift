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
}

extension FirebaseUserService: DependencyKey {
    static let liveValue = Self(
        saveUser: { user in
            try Firestore.firestore()
                .collection("users")
                .document(user.userId)
                .setData(from: user, merge: true)
        }
    )
}

extension DependencyValues {
    var firebaseUserService: FirebaseUserService {
        get { self[FirebaseUserService.self] }
        set { self[FirebaseUserService.self] = newValue }
    }
}

//
//  AuthDataResultModel.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 03/07/2025.
//

import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let creationDate: Date?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.creationDate = user.metadata.creationDate
    }
}

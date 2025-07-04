//
//  UserModel.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 03/07/2025.
//

import Foundation

struct UserModel: Codable {
    let userId: String
    let dateCreated: Date?
    let email: String?
    let name: String?
    
    init(
        userId: String,
        dateCreated: Date,
        email: String,
        name: String,
        notes: [NoteModel]
    ) {
        self.userId = userId
        self.dateCreated = dateCreated
        self.email = email
        self.name = name
    }
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.dateCreated = auth.creationDate
        self.email = auth.email
        self.name = nil
    }
    
    enum CodingKeys: String ,CodingKey {
        case userId = "user_id"
        case dateCreated = "date_created"
        case email
        case name
    }
    
    static let mock = UserModel(userId: "1", dateCreated: .now, email: "", name: "Adi", notes: [])
}

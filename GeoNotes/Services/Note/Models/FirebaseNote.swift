//
//  FirebaseNote.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 04/07/2025.
//

import Foundation
import FirebaseFirestore
import CoreLocation

struct FirebaseNote: Codable, Identifiable, Equatable {
    var id: String
    var title: String
    var body: String
    var creationDate: Date
    var location: GeoPoint?
    
    init(id: String = UUID().uuidString,
         title: String,
         body: String,
         creationDate: Date = .now,
         location: GeoPoint? = nil) {
        self.id = id
        self.title = title
        self.body = body
        self.creationDate = creationDate
        self.location = location
    }
    
    init(note: NoteModel) {
        self.id = note.id
        self.title = note.title
        self.body = note.body
        self.creationDate = note.creationDate
        if let location = note.location {
            self.location = GeoPoint(latitude: location.latitude, longitude: location.longitude)
        } else {
            self.location = nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case creationDate = "creation_date"
        case location
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.body = try container.decode(String.self, forKey: .body)
        self.creationDate = try container.decode(Date.self, forKey: .creationDate)
        self.location = try container.decodeIfPresent(GeoPoint.self, forKey: .location)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.body, forKey: .body)
        try container.encode(self.creationDate, forKey: .creationDate)
        try container.encodeIfPresent(self.location, forKey: .location)
    }
}

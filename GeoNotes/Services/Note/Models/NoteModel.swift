//
//  NoteModel.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 03/07/2025.
//

import Foundation
import MapKit

struct NoteModel: Identifiable, Equatable {
    let id: String
    let title: String
    let body: String
    let creationDate: Date
    let location: CLLocationCoordinate2D?
    
    init(
        id: String = UUID().uuidString,
        title: String,
        body: String,
        creationDate: Date,
        location: CLLocationCoordinate2D?
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.creationDate = creationDate
        self.location = location
    }
    
    init(note: FirebaseNote) {
        self.id = note.id
        self.title = note.title
        self.body = note.body
        self.creationDate = note.creationDate
        if let coordinate = note.location {
            self.location = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        } else {
            self.location = nil
        }
    }
    
    static func == (lhs: NoteModel, rhs: NoteModel) -> Bool {
        lhs.id == rhs.id
    }
    
    static var mock: NoteModel {
        mocks[0]
    }
    
    static let mocks: [NoteModel] = [
        NoteModel(
            title: "Grocery List",
            body: "Buy milk, eggs, and bread on the way home.",
            creationDate: Date(),
            location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // San Francisco
        ),
        NoteModel(
            title: "Meeting with John",
            body: "Discuss the roadmap for Q3 and finalize design decisions.",
            creationDate: Date().addingTimeInterval(-86400), // Yesterday
            location: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437) // Los Angeles
        ),
        NoteModel(
            title: "Hiking Spot",
            body: "Found a great hiking trail with amazing views!",
            creationDate: Date().addingTimeInterval(-172800), // Two days ago
            location: CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321) // Seattle
        ),
        NoteModel(
            title: "Coffee Place",
            body: "Best cappuccino I've had in a while. Worth revisiting!",
            creationDate: Date().addingTimeInterval(-3600), // An hour ago
            location: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060) // New York
        ),
        NoteModel(
            title: "Book Recommendation",
            body: "Read 'Atomic Habits' – very insightful on behavior change.",
            creationDate: Date().addingTimeInterval(-5400), // 1.5 hours ago
            location: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278) // London
        )
    ]
}

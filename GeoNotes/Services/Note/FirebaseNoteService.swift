//
//  FirebaseNoteService.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 04/07/2025.
//

import Foundation
import FirebaseFirestore
import ComposableArchitecture
import CoreLocation

@DependencyClient
struct FirebaseNotesService {
    var fetchNotes: @Sendable (_ userID: String) async throws -> [FirebaseNote]
    var addNote: @Sendable (_ userID: String, _ note: NoteModel) async throws -> Void
    var deleteNote: @Sendable (_ userID: String, _ noteID: String) async throws -> Void
}

extension FirebaseNotesService: DependencyKey {
    static let liveValue = Self(
        fetchNotes: { userId in
            do {
                let snapshot = try await Firestore.firestore()
                    .collection("users").document(userId)
                    .collection("notes")
                    .getDocuments()
                
                return try snapshot.documents.map { snapshot in
                    return try snapshot.data(as: FirebaseNote.self)
                }
            } catch {
                print("Failed to fetch notes: \(error)")
                return []
            }
        },
        
        addNote: { userId, note in
            let firebaseNote = FirebaseNote(note: note)
            _ = try Firestore.firestore()
                .collection("users").document(userId)
                .collection("notes")
                .addDocument(from: firebaseNote)
        },
        
        deleteNote: { userId, noteId in
            do {
                let querySnapshot = try await Firestore.firestore()
                    .collection("users").document(userId)
                    .collection("notes")
                    .whereField("id", isEqualTo: noteId)
                    .getDocuments()
                
                for document in querySnapshot.documents {
                    try await document.reference.delete()
                    print("Deleted note with internalId: \(noteId)")
                }
            } catch {
                print("Error delete note: \(error)")
            }
            
        }
    )
}

extension DependencyValues {
    var firebaseNotesService: FirebaseNotesService {
        get { self[FirebaseNotesService.self] }
        set { self[FirebaseNotesService.self] = newValue }
    }
}

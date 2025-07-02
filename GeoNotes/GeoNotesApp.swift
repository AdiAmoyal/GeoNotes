//
//  GeoNotesApp.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 01/07/2025.
//

import SwiftUI
import ComposableArchitecture
import Firebase

@main
struct GeoNotesApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    static let store = Store(
        initialState: AppStateFeature.State()) {
            AppStateFeature()
                ._printChanges()
        }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: GeoNotesApp.store)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

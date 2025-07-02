//
//  UserDefaults + EXT.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 02/07/2025.
//
import Foundation

extension UserDefaults {
    
    private struct Keys {
        static let showTabBarView = "showTabbarView"
    }
    
    static var showTabBarView: Bool {
        get {
            standard.bool(forKey: Keys.showTabBarView)
        }
        
        set {
            standard.set(newValue, forKey: Keys.showTabBarView)
        }
    }
}

//
//  LocationService.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 03/07/2025.
//

import Foundation
import ComposableArchitecture
import CoreLocation

@DependencyClient
struct LocationService {
    var authorizationStatus: @Sendable () -> CLAuthorizationStatus = { .notDetermined }
    var requestAuthorization: @Sendable () -> Void = {}
    var getLastKnownLocation: @Sendable () -> CLLocationCoordinate2D?
    var startUpdatingLocation: @Sendable () -> Void = {}
    var stopUpdatingLocation: @Sendable () -> Void = {}
}

extension LocationService: DependencyKey {
    static let liveValue: Self = {
        let manager = CLLocationManager()
        let delegate = LocationServiceDelegate(manager: manager)
        manager.delegate = delegate
        
        return Self(
            authorizationStatus: {
                manager.authorizationStatus
            },
            requestAuthorization: {
                manager.requestWhenInUseAuthorization()
            },
            getLastKnownLocation: {
                return delegate.lastKnownLocation
            },
            startUpdatingLocation: {
                manager.startUpdatingLocation()
            },
            stopUpdatingLocation: {
                manager.stopUpdatingLocation()
            }
        )
    }()
}

extension DependencyValues {
    var locationService: LocationService {
        get { self[LocationService.self] }
        set { self[LocationService.self] = newValue }
    }
}

final class LocationServiceDelegate: NSObject, CLLocationManagerDelegate {
    var lastKnownLocation: CLLocationCoordinate2D?
    private let manager: CLLocationManager
    
    init(manager: CLLocationManager) {
        self.manager = manager
        super.init()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location restricted")
        case .denied:
            print("Location denied")
        case .authorizedAlways:
            print("Location authorizedAlways")
        case .authorizedWhenInUse:
            print("Location authorized when in use")
            lastKnownLocation = manager.location?.coordinate
        @unknown default:
            print("Location service disabled")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
        //        if let location = locations.first?.coordinate {
        //            lastKnownLocation = location
        //            NotificationCenter.default.post(name: .locationUpdated, object: location)
        //        }
    }
}

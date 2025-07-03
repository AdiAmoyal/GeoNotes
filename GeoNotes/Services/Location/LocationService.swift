//
//  LocationService.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 03/07/2025.
//

import Foundation
import MapKit
import ComposableArchitecture

@DependencyClient
struct LocationService {
    var authorizationStatus: @Sendable () -> CLAuthorizationStatus = { .notDetermined }
    var requestAuthorization: @Sendable () -> Void
    var getCurrentLocation: @Sendable () async throws -> CLLocationCoordinate2D
}

extension LocationService: DependencyKey {
    static let liveValue = Self(
        authorizationStatus: {
            CLLocationManager.authorizationStatus()
        },
        requestAuthorization: {
            let manager = CLLocationManager()
            manager.requestWhenInUseAuthorization()
        },
        getCurrentLocation: {
            let manager = CLLocationManager()
            let delegate = LocationDelegate()
            manager.delegate = delegate
            manager.desiredAccuracy = kCLLocationAccuracyBest
            
            return try await withCheckedThrowingContinuation { continuation in
                delegate.onLocationReceived = { result in
                    switch result {
                    case .success(let coordinate):
                        continuation.resume(returning: coordinate)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
                manager.requestLocation()
            }
        }
    )
}

extension DependencyValues {
    var locationService: LocationService {
        get { self[LocationService.self] }
        set { self[LocationService.self] = newValue }
    }
}

final class LocationDelegate: NSObject, CLLocationManagerDelegate {
    var onLocationReceived: ((Result<CLLocationCoordinate2D, Error>) -> Void)?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate {
            onLocationReceived?(.success(coordinate))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onLocationReceived?(.failure(error))
    }
}

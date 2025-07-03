//
//  AddNewNoteFeature.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 03/07/2025.
//
import ComposableArchitecture
import SwiftUI
import MapKit

@Reducer
struct AddNewNoteFeature {
    
    @ObservableState
    struct State {
        var isLoading: Bool = false
        var title: String = ""
        var body: String = ""
        var location: CLLocationCoordinate2D?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case delegate(Delegate)
        case onAppear
        case locationReceived(CLLocationCoordinate2D)
        case locationFailed(String)
        case onCancelButtonPressed
        case onSaveButtonPressed
        
        enum Delegate: Equatable {
            case save
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.locationService) var locationService
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .delegate:
                return .none
            case .onAppear:
                let status = locationService.authorizationStatus()
                if status == .notDetermined {
                    locationService.requestAuthorization()
                }
                
                guard status == .authorizedWhenInUse || status == .authorizedAlways else {
                    return .send(.locationFailed("Location access denied."))
                }
                return .run { send in
                    do {
                        let location = try await locationService.getCurrentLocation()
                        await send(.locationReceived(location))
                    } catch {
                        await send(.locationFailed("Failed to get location."))
                    }
                }
            case .locationReceived(let coordinate):
                state.location = coordinate
                return .none
            case .locationFailed(let error):
                print("Error getting current location: \(error)")
                return .none
            case .onCancelButtonPressed:
                return .run { _ in await self.dismiss() }
            case .onSaveButtonPressed:
                // TODO: Add logic
                return .run { send in
                    await send(.delegate(.save))
                    await self.dismiss()
                }
            }
        }
    }
}

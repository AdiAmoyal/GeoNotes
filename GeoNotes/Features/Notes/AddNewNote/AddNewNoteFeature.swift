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
            case save(NoteModel)
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
                locationService.startUpdatingLocation()
                let status = locationService.authorizationStatus()
                
                if status == .notDetermined {
                    locationService.requestAuthorization()
                }
                
                if let location = locationService.getLastKnownLocation() {
                    return .send(.locationReceived(location))
                }
                return .none
            case .locationReceived(let coordinate):
                state.location = coordinate
                return .none
            case .locationFailed(let error):
                print("Error getting current location: \(error)")
                return .none
            case .onCancelButtonPressed:
                return .run { _ in await self.dismiss() }
            case .onSaveButtonPressed:
                let note = NoteModel(title: state.title, body: state.body, creationDate: .now, location: state.location != nil ? state.location : nil)
                return .run { send in
                    await send(.delegate(.save(note)))
                    await self.dismiss()
                }
            }
        }
    }
}

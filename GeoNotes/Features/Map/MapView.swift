//
//  MapView.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 02/07/2025.
//

import SwiftUI
import MapKit
import ComposableArchitecture

@Reducer
struct MapFeature {
    
    @ObservableState
    struct State {
        var mapRegion: EquatableCoordinateRegion = EquatableCoordinateRegion(region: MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 37.7749,
                longitude: -122.4194
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.1,
                longitudeDelta: 0.1
            )
        ))
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
    }
}

struct MapView: View {
    
    @Bindable var store: StoreOf<MapFeature> = Store(initialState: MapFeature.State(), reducer: {
        MapFeature()
    })
    
    var body: some View {
        NavigationStack {
            ZStack {
                Map(coordinateRegion: $store.mapRegion.region)
                    .ignoresSafeArea(edges: .top)
            }
        }
    }
}

struct EquatableCoordinateRegion: Equatable {
    var region: MKCoordinateRegion
    
    static func == (lhs: EquatableCoordinateRegion, rhs: EquatableCoordinateRegion) -> Bool {
        lhs.region.center.latitude == rhs.region.center.latitude &&
        lhs.region.center.longitude == rhs.region.center.longitude &&
        lhs.region.span.latitudeDelta == rhs.region.span.latitudeDelta &&
        lhs.region.span.longitudeDelta == rhs.region.span.longitudeDelta
    }
}

#Preview {
    MapView(store: Store(initialState: MapFeature.State(), reducer: {
        MapFeature()
    }))
}

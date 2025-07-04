//
//  MapView.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 02/07/2025.
//

import SwiftUI
import MapKit
import ComposableArchitecture

struct MapView: View {
    
    @Bindable var store: StoreOf<MapFeature> = Store(initialState: MapFeature.State(), reducer: {
        MapFeature()
    })
    
    var body: some View {
        ZStack {
            if store.isLoading {
                ProgressView()
            } else if !store.notes.isEmpty {
                
                Map(coordinateRegion: $store.mapRegion.region, annotationItems: store.notes) { note in
                    MapAnnotation(coordinate: note.location ?? CLLocationCoordinate2D()) {
                        NoteMapAnnotaionView()
                            .scaleEffect(store.mapLocation == note ? 1 : 0.7)
                            .shadow(radius: 10)
                            .onTapGesture {
                                store.send(.didMapLocationChanged(note))
                            }
                    }
                }
                .ignoresSafeArea(edges: .top)
            } else {
                Text("No notes yet.")
                    .foregroundColor(.secondary)
            }
            
            if !store.notes.isEmpty {
                VStack {
                    Spacer()
                    notesPreviewSection
                }
            }
        }
        .animation(.easeInOut, value: store.mapLocation)
        .animation(.easeInOut, value: store.mapRegion)
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    private var notesPreviewSection: some View {
        ZStack {
            ForEach(store.notes) { note in
                if let mapLocation = store.mapLocation {
                    if mapLocation == note {
                        NotePreviewView(note: note) {
                            store.send(.onNextButtonPressed(note))
                        }
                        .shadow(
                            color: Color.black.opacity(0.17),
                            radius: 8)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)))
                    }
                }
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

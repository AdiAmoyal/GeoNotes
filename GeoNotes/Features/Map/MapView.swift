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
        var notes: [NoteModel] = []
        var mapLocation: NoteModel?
        var mapRegion: EquatableCoordinateRegion = EquatableCoordinateRegion(region: MKCoordinateRegion())
        var mapSpan: MKCoordinateSpan = MKCoordinateSpan(
            latitudeDelta: 0.1,
            longitudeDelta: 0.1
        )
        var isLoading: Bool = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case didMapLocationChanged(NoteModel)
        case onNextButtonPressed(NoteModel)
        case notesLoaded([NoteModel])
    }
    
    @Dependency(\.firebaseAuthService) var authService
    @Dependency(\.firebaseUserService) var userService
    @Dependency(\.firebaseNotesService) var noteService
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .onAppear:
                state.isLoading = true
                //                state.notes = NoteModel.mocks
                //                state.mapLocation = state.notes.first!
                //                state.isLoading = false
                //                guard let note = state.mapLocation else { return .none }
                //                return .send(.didMapLocationChanged(note))
                return .run { send in
                    if let user = authService.currentUser() {
                        do {
                            let currentUser = try await userService.getUser(user.uid)
                            let firebaseNotes = try await noteService.fetchNotes(currentUser.userId)
                            let notes = firebaseNotes.map { NoteModel(note: $0) }
                            await send(.notesLoaded(notes))
                        } catch {
                            print("Failed to get notes: \(error)")
                        }
                    }
                }
            case .didMapLocationChanged(let note):
                state.mapLocation = note
                guard let note = state.mapLocation, let coordinates = note.location else { return .none }
                state.mapRegion = EquatableCoordinateRegion(region: MKCoordinateRegion(center: coordinates, span: state.mapSpan))
                return .none
            case .onNextButtonPressed(let note):
                guard let currentIndex = state.notes.firstIndex(where: { $0 == state.mapLocation}) else {
                    print("Could not find current index in locations array! Should never happen.")
                    return .none
                }
                let nextIndex = currentIndex + 1
                
                guard state.notes.indices.contains(nextIndex) else {
                    guard let firstNote = state.notes.first else { return .none }
                    return .send(.didMapLocationChanged(firstNote))
                }
                
                // Next index is valid
                let nextNote = state.notes[nextIndex]
                return .send(.didMapLocationChanged(nextNote))
            case .notesLoaded(let notes):
                state.notes = notes
                state.isLoading = false
                return .run { send in
                    if let note = notes.first {
                        await send(.didMapLocationChanged(note))
                    }
                }
            }
        }
    }
}

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

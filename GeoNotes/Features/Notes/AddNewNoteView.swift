//
//  AddNewNoteView.swift
//  GeoNotes
//
//  Created by Adi Amoyal on 03/07/2025.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AddNewNoteFeature {
    
    @ObservableState
    struct State {
        var isLoading: Bool = false
        var title: String = ""
        var body: String = ""
        // TODO: Add Location
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case delegate(Delegate)
        case onCancelButtonPressed
        case onSaveButtonPressed
        
        enum Delegate: Equatable {
            case save
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .delegate:
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


struct AddNewNoteView: View {
    
    @Bindable var store: StoreOf<AddNewNoteFeature>
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack(spacing: 32) {
                header
                
                VStack(spacing: 12) {
                    TextField("Title", text: $store.title, prompt: Text("Title"))
                        .padding()
                        .frame(height: 50)
                        .foregroundStyle(Color.text)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.secondary, lineWidth: 1)
                        )
                    
                    VStack(spacing: 6) {
                        Text("Body")
                            .font(.headline)
                            .foregroundStyle(Color.text)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextEditor(text: $store.body)
                            .foregroundStyle(Color.text)
                            .frame(maxHeight: 200)
                            .padding(8)
                    }
                    
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
                Button {
                    store.send(.onSaveButtonPressed)
                } label: {
                    ZStack {
                        if store.isLoading {
                            ProgressView()
                        } else {
                            Text("Save")
                        }
                    }
                    .callToActionButton()
                }
                
            }
            .padding(22)
        }
    }
    
    private var header: some View {
        HStack {
            Text("Add New Note")
            
                .frame(maxWidth: .infinity, alignment: .leading)
            
            xMarkButton
        }
        .font(.title2)
        .fontWeight(.semibold)
        .foregroundStyle(Color.text)
    }
    
    private var xMarkButton: some View {
        Image(systemName: "xmark")
            .onTapGesture {
                store.send(.onCancelButtonPressed)
            }
            .tappableBackground()
    }
}

#Preview {
    AddNewNoteView(store: Store(initialState: AddNewNoteFeature.State(), reducer: {
        AddNewNoteFeature()
    }))
}

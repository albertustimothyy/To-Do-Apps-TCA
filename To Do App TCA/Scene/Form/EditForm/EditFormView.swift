//
//  EditFormView.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 18/03/24.
//

import SwiftUI
import ComposableArchitecture

struct EditFormView: View {
    @Bindable var store: StoreOf<EditFormFeature>
    
    var body: some View {
        Form {
            
        }
        .toolbar {
            ToolbarItem {
                Button {
                    store.send(.xMarkTapped)
                } label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
            }
        }
    }
}

#Preview {
    EditFormView(
        store: Store(
            initialState: EditFormFeature.State(
                type: .general,
                generalToDo: GeneralToDo(name: "Hai", description: "APA YA", done: false, deadline: Date())
            )
        ) {
            EditFormFeature()
        }
    )
}

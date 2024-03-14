//
//  WorkFormView.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 16/03/24.
//

import SwiftUI
import ComposableArchitecture

struct WorkFormView: View {
    @Bindable var store: StoreOf<WorkFormFeature>
    
    var body: some View {
        Section(header: Text("Work To Do")) {
            TextField("Enter Project's Name", text: $store.workToDo.project.sending(\.setProject))
            LabeledContent("Estimation Hours") {
                HStack {
                    Button {
                        store.send(.decrementButtonTapped)
                    } label: {
                        Image(systemName: "minus.circle")
                            .foregroundStyle(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Text("\(store.workToDo.hoursEstimate) hours")
                    
                    Button {
                        store.send(.incrementButtonTapped)
                    } label: {
                        Image(systemName: "plus.circle")
                            .foregroundStyle(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

#Preview {
    WorkFormView(
        store: Store(initialState: WorkFormFeature.State(
            workToDo: WorkToDo(
                name: "",
                description: "",
                done: false,
                project: "",
                hoursEstimate: 0,
                deadline: Date()
            )
        )
        ){
            WorkFormFeature()
        }
    )
}

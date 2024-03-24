//
//  AddFormView.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 16/03/24.
//

import SwiftUI
import ComposableArchitecture

struct AddFormView: View {
    @Bindable var store: StoreOf<AddFormFeature>
    
    var body: some View {
        Form {
            HStack {
                Spacer()
                
                Text(store.editForm ? "Edit To Do" : "Add To Do")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
            }
            .scrollContentBackground(.hidden)
            Section(header: Text("General Information")) {
                
                TextField(
                    "Enter Task Name",
                    text: $store.inputName.sending(\.setName)
                )
                
                TextField(
                    "Enter Description",
                    text: $store.inputDescription.sending(\.setDescription)
                )
                
                
                DatePicker(
                    selection: $store.inputDeadline.sending(\.setDeadline),
                    in: Date.now...,
                    displayedComponents: .date,
                    label: { Text("Deadline") }
                )
                
                if(!store.editForm) {
                    Picker(
                        "Type",
                        selection: $store.inputType.sending(\.setType)
                    ) {
                        Text("General")
                            .tag(ToDoType.general)
                        Text("Work")
                            .tag(ToDoType.work)
                        Text("Travel")
                            .tag(ToDoType.travel)
                        Text("Shop")
                            .tag(ToDoType.shop)
                    }
                }
            }
            
            switch store.inputType {
            case .general:
                EmptyView()
            case .work:
                WorkFormView(
                    store: store.scope(state: \.workData, action: \.workData) ??
                    Store(
                        initialState: WorkFormFeature.State(
                            workToDo: WorkToDo(
                                name: store.inputName,
                                description: store.inputDescription,
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
            case .shop:
                ShopFormView(
                    store: store.scope(state: \.shopData, action: \.shopData) ??
                    Store(
                        initialState: ShopFormFeature.State(
                            shopToDo: ShopToDo(
                                name: "",
                                description: "",
                                done: false,
                                deadline: Date(),
                                shoppingList: []
                            )
                        )
                    ){
                        ShopFormFeature()
                    }
                )
            case .travel:
                TravelFormView(
                    store: store.scope(
                        state: \.travelData,
                        action: \.travelData
                    ) ??
                    Store(
                        initialState: TravelFormFeature.State(
                            travelToDo: TravelToDo(
                                name: "",
                                description: "",
                                done: false,
                                deadline: Date(timeIntervalSinceNow: 172800),
                                destination: TravelToDo.Coordinates(latitude: 0, longitude: 0),
                                startDate: Date(),
                                endDate: Date(timeIntervalSinceNow: 86400)
                            )
                        )
                    ) {
                        TravelFormFeature()
                    }
                )
            }
            
            Button {
                store.send(.saveButtonTapped)
            } label: {
                Text("Save")
                    .font(.title3)
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity)
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    store.send(.closeTapped)
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
    NavigationStack {
        AddFormView(
            store: Store(
                initialState: AddFormFeature.State(
                    editForm: false,
                    inputName: "",
                    inputDescription: "",
                    inputDeadline: Date(),
                    inputDone: false,
                    inputType: .general
                )
            ) {
                AddFormFeature()
            }
        )
    }
}

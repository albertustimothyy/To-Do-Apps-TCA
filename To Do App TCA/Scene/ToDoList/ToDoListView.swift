//
//  ToDoListView.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 15/03/24.
//

import SwiftUI
import ComposableArchitecture

struct ToDoListView: View {
    @Bindable var store: StoreOf<ToDoListFeature>
    
    var body: some View {
        NavigationStack(
            path: $store.scope(
                state: \.path,
                action: \.path
            )
        ) {
            List {
                ForEach(store.toDos) { toDo in
                    NavigationLink(state: DetailFeature.State(
                            toDo: toDo
                        )
                    ) {
                        HStack{
                            ToDoRowView(
                                store: Store(initialState: ToDoRowFeature.State(toDo: toDo)) {
                                    ToDoRowFeature()
                                }
                            )
                            Button {
                                store.send(.deleteButtonTapped(id: toDo.id))
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(PlainButtonStyle())

                        }
                    }
                }
            }
            .navigationTitle("To Do List App")
            .toolbar {
                ToolbarItem {
                    Button {
                        store.send(.addButtonTapped)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        } destination: { store in
        DetailView(store: store)
    }
        .sheet(
            item: $store.scope(
                state: \.destination?.addToDo,
                action: \.destination.addToDo
            )
        ) {addFormStore in
            NavigationStack {
                AddFormView(store: addFormStore)
            }
        }
        .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
    }
}

#Preview {
    ToDoListView(
        store: Store(
            initialState: ToDoListFeature.State(
                toDos: [
                    AnyToDo(
                        GeneralToDo(
                            name: "First Task",
                            description: "Finish it before 12 March 2024",
                            done: false,
                            deadline: Date()
                        ),
                        .general
                    ),
                    AnyToDo(
                        GeneralToDo(
                            name: "Second Task",
                            description: "Finish it before 12 March 2024",
                            done: false,
                            deadline: Date()
                        ),
                        .general
                    ),
                    AnyToDo(
                        GeneralToDo(
                            name: "Third Task",
                            description: "Finish it before 12 March 2024",
                            done: false,
                            deadline: Date()

                        ),
                        .general
                    )
                ]
            )
        ) {
            ToDoListFeature()
        }
    )
}

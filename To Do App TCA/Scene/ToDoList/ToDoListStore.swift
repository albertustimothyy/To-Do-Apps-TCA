//
//  ToDoListStore.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 15/03/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ToDoListFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var toDos: IdentifiedArrayOf<ToDoRowFeature.State>
        var path = StackState<DetailFeature.State>()
    }
    
    enum Action {
        case addButtonTapped
        case toggleDone
        case toDos(IdentifiedActionOf<ToDoRowFeature>)
        case destination(PresentationAction<Destination.Action>)
        case deleteButtonTapped(id: AnyToDo.ID)
        case path(StackAction<DetailFeature.State, DetailFeature.Action>)
        enum Alert: Equatable {
            case confirmDeletion(id: AnyToDo.ID)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.destination = .addToDo(
                    AddFormFeature.State(
                        editForm: false,
                        inputName: "",
                        inputDescription: "",
                        inputDeadline: Date(),
                        inputDone: false, 
                        inputType: .general
                    )
                )
                return .none
                
            case let .destination(.presented(.alert(.confirmDeletion(id: id)))):
                state.toDos.remove(id: id)
                return .none
                
            case let .destination(.presented(.addToDo(.delegate(.saveToDo(toDo))))):
                let newToDo = ToDoRowFeature.State(toDo: toDo)
                state.toDos.append(newToDo)
                return .none
                
            case .destination:
                return .none
                
            case let .deleteButtonTapped(id: id):
                state.destination = .alert(
                    AlertState {
                        TextState("Are you sure?")
                    } actions: {
                        ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                            TextState("Delete")
                        }
                    }
                )
                return .none
                
            case let .toDos(.element(id: id, action: .delegate(.toggleDone))):
//                print("todos ", id)
                state.toDos[id: id]?.toDo.base.done.toggle()
                return .none
                
            case let .path(.element(id: id, action: .delegate(.editToDo))):
                guard let detailState = state.path[id: id]
                else { return .none }
                state.toDos[id: detailState.toDo.id]?.toDo = detailState.toDo
//                print(state.path[id: id]?.toDo)
                return .none
                
            case .toggleDone:
                return .none
                
            case .path:
                return .none
                
            case .toDos:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .forEach(\.path, action: \.path) {
            DetailFeature()
        }
        .forEach(\.toDos, action: \.toDos) {
            ToDoRowFeature()
        }
    }
}

extension ToDoListFeature {
    @Reducer(state: .equatable)
    enum Destination {
        case addToDo(AddFormFeature)
        case alert(AlertState<ToDoListFeature.Action.Alert>)
    }
}

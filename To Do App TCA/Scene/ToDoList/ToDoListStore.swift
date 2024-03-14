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
        var toDos: IdentifiedArrayOf<AnyToDo> = []
        var path = StackState<DetailFeature.State>()
    }
    
    enum Action {
        case addButtonTapped
        case toggleDone
        case toDos
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
                        inputType: .general
                    )
                )
                return .none
                
            case let .destination(.presented(.alert(.confirmDeletion(id: id)))):
                state.toDos.remove(id: id)
                return .none
                
            case let .destination(.presented(.addToDo(.delegate(.saveToDo(toDo))))):
                state.toDos.append(toDo)
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
                
                
            case .toDos:
                return .none
                
            case .path:
                return .none
                
            case .toggleDone:
                return .none
                
            }
            
        }
        .ifLet(\.$destination, action: \.destination)
        .forEach(\.path, action: \.path) {
            DetailFeature()
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

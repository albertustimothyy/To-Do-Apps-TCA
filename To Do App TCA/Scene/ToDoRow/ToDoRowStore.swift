//
//  ToDoRowStore.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 15/03/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ToDoRowFeature {
    @ObservableState
    struct State: Equatable, Identifiable {
        var id: String = UUID().uuidString
        var path = StackState<DetailFeature.State>()

        var toDo: AnyToDo
    }
    
    enum Action {
        case checkBoxTapped
        case path(StackAction<DetailFeature.State, DetailFeature.Action>)
        case delegate(Delegate)
        enum Delegate {
            case toggleDone
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .checkBoxTapped:
                return .send(.delegate(.toggleDone))
                
            case .delegate:
                return .none
          
            case .path:
                return .none
    
            }
        }
        .forEach(\.path, action: \.path) {
            DetailFeature()
        }
    }
}

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
    struct State: Equatable {
        var toDo: AnyToDo
    }
    
    enum Action {
        case checkBoxTapped
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
          
            }
        }
    }
}

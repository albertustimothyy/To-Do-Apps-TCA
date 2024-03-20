//
//  WorkFormStore.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 16/03/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WorkFormFeature {
    @ObservableState
    struct State: Equatable {
        var workToDo: WorkToDo
    }

    enum Action {
        case setProject(String)
        case decrementButtonTapped
        case incrementButtonTapped
        case setDeadline(Date)
    }
        
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case let .setProject(project):
                state.workToDo.project = project
                return .none
                
            case .decrementButtonTapped:
                if (state.workToDo.hoursEstimate > 0) {
                    state.workToDo.hoursEstimate -= 1
                }
                return .none
                
            case .incrementButtonTapped:
                state.workToDo.hoursEstimate += 1
                return .none
                
            case let .setDeadline(deadline):
                state.workToDo.deadline = deadline
                return .none
            }
        }
    }
}


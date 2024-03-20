//
//  TravelFormStore.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 19/03/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TravelFormFeature {
    @ObservableState
    struct State: Equatable {
        var travelToDo: TravelToDo
    }
    
    enum Action {
        case setStartDate(Date)
        case setEndDate(Date)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case var .setStartDate(startDate):
                if startDate > state.travelToDo.endDate {
                    state.travelToDo.endDate = startDate
                }
                if startDate > state.travelToDo.deadline {
                    startDate = state.travelToDo.deadline
                }
                state.travelToDo.startDate = startDate
                return .none
                
            case var .setEndDate(endDate):
                if endDate < state.travelToDo.startDate {
                    state.travelToDo.startDate = endDate
                }
                if endDate > state.travelToDo.deadline {
                    endDate = state.travelToDo.deadline
                }
                state.travelToDo.endDate = endDate
                return .none
            }
        }
    }
}

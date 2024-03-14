//
//  EditFormStore.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 18/03/24.
//

import Foundation
import ComposableArchitecture

enum ToDoItem {
    case general(GeneralToDo)
    case shop(ShopToDo)
    case travel(TravelToDo)
    case work(WorkToDo)
}

@Reducer
struct EditFormFeature {
    @ObservableState
    struct State: Equatable {
        var type: ToDoType
        var generalToDo: GeneralToDo?
        var workToDo: WorkToDo?
        var travelToDo: TravelToDo?
        var shopToDo: ShopToDo?
    }
    
    enum Action {
        case xMarkTapped
        case setName(String)
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce {state, action in
            switch action {
                
            case .xMarkTapped:
                return .run { _ in
                    await self.dismiss()
                }
                
           
            case let .setName(name):
                state.generalToDo?.name = name
                state.shopToDo?.name = name
                state.travelToDo?.name = name
                state.workToDo?.name = name
                return .none
            }
        }
    }
}

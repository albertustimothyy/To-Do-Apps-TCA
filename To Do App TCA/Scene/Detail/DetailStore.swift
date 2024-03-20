//
//  DetailStore.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 15/03/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DetailFeature {
    @ObservableState
    struct State: Equatable {
        var toDo: AnyToDo
        @Presents var editToDo: AddFormFeature.State?
        var travelToDo: TravelToDo?
    }
    
    enum Action {
        case editButtonTapped
        case editToDo(PresentationAction<AddFormFeature.Action>)
        case delegate(Delegate)
        enum Delegate {
            case editToDo(AnyToDo)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .editButtonTapped:
                switch state.toDo.typee {
                case .general:
                    if let anyToDo = state.toDo.base as? GeneralToDo {
                        state.editToDo = AddFormFeature.State(
                            editForm: true,
                            inputName: anyToDo.name,
                            inputDescription: anyToDo.description,
                            inputDeadline: anyToDo.deadline,
                            inputDone: anyToDo.done,
                            inputType: .general
                        )
                    }
                    
                case .shop:
                    if let anyToDo = state.toDo.base as? ShopToDo {
                        state.editToDo = AddFormFeature.State(
                            editForm: true,
                            inputName: anyToDo.name,
                            inputDescription: anyToDo.description,
                            inputDeadline: anyToDo.deadline,
                            inputDone: anyToDo.done, 
                            inputType: .shop,
                            shopData: ShopFormFeature.State(shopToDo: anyToDo)
                        )
                    }
                    
                case .travel:
                    if let anyToDo = state.toDo.base as? TravelToDo {
                        state.travelToDo = anyToDo
                        state.editToDo = AddFormFeature.State(
                            editForm: true,
                            inputName: anyToDo.name,
                            inputDescription: anyToDo.description,
                            inputDeadline: anyToDo.deadline,
                            inputDone: anyToDo.done,
                            inputType: .travel,
                            travelData: TravelFormFeature.State(travelToDo: anyToDo)
                        )
                    }
                    
                case .work:
                    if let anyToDo = state.toDo.base as? WorkToDo{
                        state.editToDo = AddFormFeature.State(
                            editForm: true,
                            inputName: anyToDo.name,
                            inputDescription: anyToDo.description,
                            inputDeadline: anyToDo.deadline,
                            inputDone: anyToDo.done, 
                            inputType: .work,
                            workData: WorkFormFeature.State(workToDo: anyToDo)
                        )
                    }
                }
                return .none
                
            case let .editToDo(.presented(.delegate(.saveToDo(toDo)))):
                state.toDo = toDo
                return  .run { [toDo = state.toDo] send in
                    await send(.delegate(.editToDo(toDo)))
                }
                
            case .editToDo:
                return .none
     
            case .delegate:
                return .none
            }
        }
        .ifLet(\.$editToDo, action: \.editToDo) {
            AddFormFeature()
        }
    }
}

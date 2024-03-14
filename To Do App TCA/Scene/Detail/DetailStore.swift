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
                            inputType: .shop,
                            shopData: ShopFormFeature.State(shopToDo: anyToDo)
                        )
                    }
                case .travel:
                    if let anyToDo = state.toDo.base as? TravelToDo? {
                        state.travelToDo = anyToDo
                        state.editToDo = AddFormFeature.State(
                            editForm: true,
                            inputName: anyToDo?.name ?? "",
                            inputDescription: anyToDo?.description ?? "",
                            inputDeadline: anyToDo?.deadline ?? Date(),
                            inputType: .travel,
                            travelData: TravelFormFeature.State(travelToDo: anyToDo!)
                        )
                    }
                case .work:
                    if let anyToDo = state.toDo.base as? WorkToDo{
                        state.editToDo = AddFormFeature.State(
                            editForm: true,
                            inputName: anyToDo.name,
                            inputDescription: anyToDo.description,
                            inputDeadline: anyToDo.deadline,
                            inputType: .work,
                            workData: WorkFormFeature.State(workToDo: anyToDo)
                        )
                    }
                }
               
//                switch state.toDo.typee {
//                case .general:
//                    if let generalToDo = state.toDo.base as? GeneralToDo? {
//                        state.editToDo = EditFormFeature.State(
//                            type: .general,
//                            generalToDo: generalToDo
//                        )
//                    }
//                case .shop:
//                    if let shopToDo = state.toDo.base as? ShopToDo? {
//                        state.editToDo = EditFormFeature.State(
//                            type: .shop,
//                            shopToDo: shopToDo
//                        )
//                    }
//                case .travel:
//                    if let travelToDo = state.toDo.base as? TravelToDo? {
//                        state.editToDo = EditFormFeature.State(
//                            type: .travel,
//                            travelToDo: travelToDo
//                        )
//                    }
//                case .work:
//                    if let workToDo = state.toDo.base as? WorkToDo? {
//                        state.editToDo = EditFormFeature.State(
//                            type: .work,
//                            workToDo: workToDo
//                        )
//                    }
//                }
               
                return .none
                
//            case let .destination(.presented(.addToDo(.delegate(.saveToDo(toDo))))):
//                state.toDos.append(toDo)
//                return .none
                
            case let .editToDo(.presented(.delegate(.saveToDo(toDo)))):
                state.toDo = toDo
                return .none
                
            case .editToDo:
                return .none
     
            }
        }
        .ifLet(\.$editToDo, action: \.editToDo) {
//            EditFormFeature()
            AddFormFeature()
        }
    }
}

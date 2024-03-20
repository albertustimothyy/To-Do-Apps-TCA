//
//  AddFormStore.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 16/03/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AddFormFeature {
    @ObservableState
    struct State: Equatable {
        var toDo: AnyToDo?
        var editForm: Bool
        var inputName: String
        var inputDescription: String
        var inputDeadline: Date
        var inputDone: Bool
        var inputType: ToDoType
        var workData: WorkFormFeature.State?
        var shopData: ShopFormFeature.State?
        var travelData: TravelFormFeature.State?
    }
    
    enum Action {
        case xMarkTapped
        case setName(String)
        case setDescription(String)
        case setType(ToDoType)
        case setDeadline(Date)
        case setDone(Bool)
        case workData(WorkFormFeature.Action)
        case shopData(ShopFormFeature.Action)
        case travelData(TravelFormFeature.Action)
        case saveButtonTapped
        case delegate(Delegate)
        enum Delegate: Equatable {
            case saveToDo(AnyToDo)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .xMarkTapped:
                state.workData = nil
                state.shopData = nil
                state.travelData = nil
                return .run { _ in
                    await self.dismiss()
                }
                
            case let .setName(name):
                state.inputName = name
                switch state.inputType {
                case .general:
                    break
                case .shop:
                    state.shopData?.shopToDo.name = name
                case .travel:
                    state.travelData?.travelToDo.name = name
                case .work:
                    state.workData?.workToDo.name = name
                }
                return .none
                
            case let .setDescription(desc):
                state.inputDescription = desc
                switch state.inputType {
                case .general:
                    break
                case .shop:
                    state.shopData?.shopToDo.description = desc
                case .travel:
                    state.travelData?.travelToDo.description = desc
                case .work:
                    state.workData?.workToDo.description = desc
                }
                return .none
                
            case let .setDeadline(deadline):
                state.inputDeadline = deadline
                switch state.inputType {
                case .general:
                    break
                case .shop:
                    state.shopData?.shopToDo.deadline = deadline
                case .travel:
                    state.travelData?.travelToDo.deadline = deadline
                case .work:
                    state.workData?.workToDo.deadline = deadline
                }
                return .none
                
            case let .setDone(done):
                if state.editForm == true {
                    state.inputDone = done
                } else {
                    state.inputDone = false
                }
                return.none
                
            case let .setType(type):
                state.inputType = type
                switch state.inputType {
                case .general:
                    state.workData = nil
                    state.shopData = nil
                    state.travelData = nil
                case .shop:
                    state.shopData = ShopFormFeature.State(
                        shopToDo: ShopToDo(
                            name: state.inputName,
                            description: state.inputDescription,
                            done: state.inputDone,
                            deadline: state.inputDeadline,
                            shoppingList: []
                        )
                    )
                    state.workData = nil
                    state.travelData = nil
                case .travel:
                    state.travelData = TravelFormFeature.State(
                        travelToDo: TravelToDo(
                            name: state.inputName,
                            description: state.inputDescription,
                            done: state.inputDone,
                            deadline: state.inputDeadline,
                            destination: TravelToDo.Coordinates(latitude: 0, longitude: 0),
                            startDate: Date(),
                            endDate: Date(timeIntervalSinceNow: 86400)
                        )
                    )
                    state.workData = nil
                    state.shopData = nil
                case .work:
                    state.workData = WorkFormFeature.State(
                        workToDo: WorkToDo(
                            name: state.inputName,
                            description: state.inputDescription, 
                            done: state.inputDone,
                            project: "",
                            hoursEstimate: 0,
                            deadline: state.inputDeadline
                        )
                    )
                    state.shopData = nil
                    state.travelData = nil
                }
                return .none
                
            case .saveButtonTapped:
                switch state.inputType {
                case .general:
                    let toDo = GeneralToDo(
                        name: state.inputName,
                        description: state.inputDescription,
                        done: state.inputDone,
                        deadline: state.inputDeadline
                    )
                    state.toDo = AnyToDo(toDo, .general)
                    state.workData = nil
                    state.shopData = nil
                    state.travelData = nil
                case .shop:
                    guard let toDo = state.shopData?.shopToDo else { return .none }
                    state.toDo = AnyToDo(toDo, .shop)
                    state.workData = nil
                    state.travelData = nil
                case .travel:
                    guard let toDo = state.travelData?.travelToDo else { return .none }
                    state.toDo = AnyToDo(toDo, .travel)
                    state.workData = nil
                    state.shopData = nil
                    state.travelData = nil
                case .work:
                    guard let toDo = state.workData?.workToDo else { return .none }
                    state.toDo = AnyToDo(toDo, .work)
                    state.workData = nil
                    state.shopData = nil
                    state.travelData = nil
                }
                
                return .run { [toDo = state.toDo] send in
                    await send(
                        .delegate(
                            .saveToDo(
                                toDo ?? AnyToDo(
                                    GeneralToDo(
                                        name: "kosong",
                                        description: "",
                                        done: false,
                                        deadline: Date()),
                                        .general
                                )
                            )
                        )
                    )
                    await dismiss()
                }
                
            case .workData:
                return .none
                
            case .shopData:
                return .none
                
            case .travelData:
                return .none
                
            case .delegate:
                return .none
            }
        }
        .ifLet(\.workData, action: \.workData) {
            WorkFormFeature()
        }
        .ifLet(\.shopData, action: \.shopData) {
            ShopFormFeature()
        }
        .ifLet(\.travelData, action: \.travelData) {
            TravelFormFeature()
        }
    }
}

extension AddFormFeature {
    @Reducer(state: .equatable)
    enum AddToDo {
        case addWork(WorkFormFeature)
    }
}

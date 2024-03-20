//
//  ShopFormStore.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 16/03/24.
//

import Foundation
import Combine
import ComposableArchitecture
import SwiftUI

@Reducer
struct ShopFormFeature {
    @ObservableState
    struct State: Equatable {
        var shopToDo: ShopToDo
        var shoppingItems: IdentifiedArrayOf<ShopItemFeature.State> = []
        var image: Image?
        var inputImage: UIImage?
    }
    
    enum Action {
        case addButtonTapped
        case shoppingItems(IdentifiedActionOf<ShopItemFeature>)
        case deleteItem(id: ShoppingItem.ID)
        case updateShoppingList([ShoppingItem])
        //        case addItemsToShoppingList
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.shoppingItems.append(
                    ShopItemFeature.State(
                        item: ShoppingItem(
                            productName: "",
                            photo: "",
                            budget: 0
                        )
                    )
                )
                return .none
                
            case let .deleteItem(id: id):
                state.shoppingItems.remove(id: id)
                return .none
                
            case let .shoppingItems(.element(id: id, action: .delegate(.deleteItem))):
                state.shoppingItems.remove(id: id)
                state.shopToDo.shoppingList = state.shoppingItems.map { $0.item }
                return .none
                
                
            case .shoppingItems(.element(id: _, action: .delegate(.updateShoppingList))):
                state.shopToDo.shoppingList = state.shoppingItems.map { $0.item }
                return .none
                
            case .shoppingItems:
                return .none
                
                
            case let .updateShoppingList(shoppingItems):
                state.shopToDo.shoppingList = shoppingItems
                return .none
            }
        }
        .forEach(\.shoppingItems, action: \.shoppingItems) {
            ShopItemFeature()
        }
        
    }
}

//
//  ShopItemStore.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 17/03/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct ShopItemFeature {
    @ObservableState
    struct State: Equatable, Identifiable {
        var id: String = UUID().uuidString
        var image: Image?
        var item: ShoppingItem
        var inputImage: UIImage?
        init(image: Image? = nil, item: ShoppingItem, inputImage: UIImage? = nil) {
            self.image = ImageHelper().decodeImage(photo: item.photo)
            self.item = item
            self.inputImage = inputImage
        }
    }
    
    enum Action {
        case decodeImage
        case loadImage
        case setName(String)
        case setBudget(Float)
        case setImage(UIImage?)
        case deleteButtonTapped
        case updateShoppingList
        case delegate(Delegate)
        enum Delegate {
            case deleteItem
            case updateShoppingList
        }
    }
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action{
            case .decodeImage:
                state.image = ImageHelper().decodeImage(photo: state.item.photo)
                return .none
                
            case .loadImage:
                state.image = ImageHelper().loadImage(photo: state.inputImage)
                state.item.photo = ImageHelper().encodeImage(inputImage: state.inputImage)
                return .none
                
            case let .setName(name):
                state.item.productName = name
                return .send(.updateShoppingList)

            case let .setBudget(budget):
                state.item.budget = budget
                return .send(.updateShoppingList)

            case let .setImage(image):
                state.inputImage = image
                return .send(.updateShoppingList)
                
            case .deleteButtonTapped:
                state.image = nil
                state.inputImage = nil
                return .send(.delegate(.deleteItem))
                
                
            case .delegate:
                return .none
                
            case .updateShoppingList:
                return .send(.delegate(.updateShoppingList))
            }
        }
    }
}

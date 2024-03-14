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
        var showingImagePicker: Bool = false
        var inputImage: UIImage?
    }
    
    enum Action {
        case decodeImage
        case showingImagePicker
        case loadImage
        case encodeImage
        case setName(String)
        case setBudget(Float)
        case setImage(UIImage?)
        case deleteButtonTapped
        case delegate(Delegate)
        enum Delegate {
            case deleteItem
        }
    }
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action{
                
            case .decodeImage:
                let dataDecoded: Data = Data(base64Encoded: state.item.photo, options: .ignoreUnknownCharacters)!
                let decodedImage = UIImage(data:  dataDecoded)
                state.image = Image(uiImage: decodedImage ?? UIImage())
                return .none
                
            case .showingImagePicker:
                state.showingImagePicker.toggle()
                return .none
                
            case .loadImage:
                guard let inputImage = state.inputImage else { return .none }
                state.image = Image(uiImage: inputImage)
                return .none
                
            case .encodeImage:
                if let inputData = state.inputImage?.pngData() {
                    let strBase64 = inputData.base64EncodedString(options: .lineLength64Characters)
                    state.item.photo = strBase64
                }
                return .none
                
            case let .setName(name):
                state.item.productName = name
                return .none
                
            case let .setBudget(budget):
                state.item.budget = budget
                return .none
                
            case let .setImage(image):
                state.inputImage = image
                return .none
                
            case .deleteButtonTapped:
                state.image = nil
                state.inputImage = nil
                return .send(.delegate(.deleteItem))
                
            case .delegate:
                return .none
            }
        }
    }
}

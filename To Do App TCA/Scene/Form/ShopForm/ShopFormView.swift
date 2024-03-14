//
//  ShopFormView.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 16/03/24.
//

import SwiftUI
import Combine
import ComposableArchitecture

struct ShopFormView: View {
    @Bindable var store: StoreOf<ShopFormFeature>
    var body: some View {
        Section(header: Text("Shop To Do")) {
            ForEachStore(
                store.scope(state: \.shoppingItems, action: \.shoppingItems)
            ) { item in
                ShopItemView(store: item)
            }

            HStack(alignment: .center) {
                Spacer()
                Button {
                    store.send(.addButtonTapped)
                } label: {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Product")
                }
                Spacer()
            }
            .foregroundStyle(.blue)
            .buttonStyle(PlainButtonStyle())
            .onReceive(Just(store.shoppingItems)) {
                shoppingItems in
                let allShoppingItems = shoppingItems.map(\.item)
                store.send(.updateShoppingList(allShoppingItems))
            }
        }
    }
}

#Preview {
    ShopFormView(
        store: Store(initialState: ShopFormFeature.State(
            shopToDo: ShopToDo(
                name: "",
                description: "",
                done: false,
                deadline: Date(),
                shoppingList: []
            ),
            shoppingItems: []
        )
        ) {
            ShopFormFeature()
        }
    )
}


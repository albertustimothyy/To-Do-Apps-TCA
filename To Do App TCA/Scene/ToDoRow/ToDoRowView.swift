//
//  ToDoRowView.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 15/03/24.
//

import SwiftUI
import ComposableArchitecture

struct ToDoRowView: View {
    @Bindable var store: StoreOf<ToDoRowFeature>
    var body: some View {
        VStack {
            HStack {
                checkBoxButton()
                
                Spacer()
                
                typeLabel()
            }
        }
    }
    
    @ViewBuilder
    func checkBoxButton() -> some View {
        Button {
            store.send(.checkBoxTapped)
        } label: {
            HStack {
                Image(
                    systemName: store.toDo.base.done ?
                    "checkmark.square.fill" : "square"
                )
                .foregroundStyle(store.toDo.base.done ? .blue : .gray)
                
                VStack(alignment: .leading) {
                    let name = store.toDo.base.name.prefix(20) + (store.toDo.base.name.count > 20 ? "..." : "")
                    let description = store.toDo.base.description.prefix(30) + (store.toDo.base.description.count > 30 ? "..." : "")
                    
                    Text(name)
                        .font(.subheadline)
                        .strikethrough(
                            store.toDo.base.done ? true : false
                        )
                    
                    Text(description)
                        .font(.caption2)
                        .foregroundStyle(.gray)
                        .italic()
                        .strikethrough(
                            store.toDo.base.done ? true : false
                        )
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    func typeLabel() -> some View {
        Text(store.toDo.typee.rawValue.capitalized)
            .font(.caption)
            .foregroundStyle(.white)
            .padding(6)
            .background( Group {
                switch store.toDo.typee {
                case .general:
                    Color.blue
                case .shop:
                    Color.mint
                case .travel:
                    Color.green
                case .work:
                    Color.brown
                }
            })
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding()
    }
}

#Preview {
    ToDoRowView(
        store: Store(
            initialState: ToDoRowFeature.State(
                toDo: AnyToDo(
                    GeneralToDo(
                        name: "First Task",
                        description: "Finish it before 12 March 2024",
                        done: false,
                        deadline: Date()
                    ),
                    .general
                )
            )
        ) {
            ToDoRowFeature()
        }
    )
}

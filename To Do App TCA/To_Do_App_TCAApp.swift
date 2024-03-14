//
//  To_Do_App_TCAApp.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 14/03/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct To_Do_App_TCAApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ToDoListView(
                store: Store(
                    initialState: ToDoListFeature.State(
                        toDos: [
                            AnyToDo(
                                GeneralToDo(
                                    name: "First Task",
                                    description: "Finish it before 12 March 2024",
                                    done: false,
                                    deadline: Date()
                                ),
                                .general
                            ),
                            AnyToDo(
                                GeneralToDo(
                                    name: "Second Task",
                                    description: "Finish it before 12 March 2024",
                                    done: false,
                                    deadline: Date()
                                ),
                                .general
                            ),
                            AnyToDo(
                                GeneralToDo(
                                    name: "Third Task",
                                    description: "Finish it before 12 March 2024",
                                    done: false,
                                    deadline: Date()
                                ),
                                .general
                            )
                        ]
                    )
                ) {
                    ToDoListFeature()
                }
            )
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            ToDoListView()
        }
    }
}

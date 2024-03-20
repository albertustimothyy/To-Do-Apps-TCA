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
//    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ToDoListView(
                store: Store(
                    initialState: ToDoListFeature.State(toDos: [
                        ToDoRowFeature.State(
                            toDo: AnyToDo(
                                GeneralToDo(
                                    name: "First Task",
                                    description: "Finish it before 12 March 2024",
                                    done: false,
                                    deadline: Date()
                                ),
                                .general
                            )
                        ),
                        ToDoRowFeature.State(
                            toDo: AnyToDo(
                                GeneralToDo(
                                    name: "First DASDASDSA",
                                    description: "Finish it before 13 March 2024",
                                    done: false,
                                    deadline: Date()
                                ),
                                .general
                            )
                        ),
                        ToDoRowFeature.State(
                            toDo: AnyToDo(
                                GeneralToDo(
                                    name: "First DSADADSADSAD",
                                    description: "Finish it before 14 March 2024",
                                    done: false,
                                    deadline: Date()
                                ),
                                .general
                            )
                        ),
                    ])
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

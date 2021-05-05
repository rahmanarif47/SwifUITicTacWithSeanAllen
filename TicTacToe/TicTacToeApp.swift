//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by Arif Rahman Sidik on 05/05/21.
//

import SwiftUI

@main
struct TicTacToeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

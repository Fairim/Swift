//
//  StudentAssistentsApp.swift
//  StudentAssistents
//
//  Created by Руслан Ахметсафин on 21.10.2025.
//

import SwiftUI

@main
struct StudentAssistentsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

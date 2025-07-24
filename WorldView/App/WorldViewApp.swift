//
//  WorldViewApp.swift
//  WorldView
//
//  Created by Mina Gerges on 23/07/2025.
//

import SwiftUI
import SwiftData

@main
struct WorldViewApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CountryEntity.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

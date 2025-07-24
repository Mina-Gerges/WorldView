//
//  ContentView.swift
//  WorldView
//
//  Created by Mina Gerges on 23/07/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [CountryEntity]

    var body: some View {
        Text("This is a placeholder")
    }
}

#Preview {
    ContentView()
        .modelContainer(for: CountryEntity.self, inMemory: true)
}

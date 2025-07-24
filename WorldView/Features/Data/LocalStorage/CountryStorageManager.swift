//
//  CountryStorageManager.swift
//  WorldView
//
//  Created by Mina Gerges on 24/07/2025.
//

import Foundation
import SwiftData

@ModelActor
actor CountryStorageManager {
    func saveCountry(_ country: CountryEntity) throws {
        modelContext.insert(country)
        try modelContext.save()
    }

    func deleteCountry(_ country: CountryEntity) throws {
        modelContext.delete(country)
        try modelContext.save()
    }

    func fetchSavedCountries() throws -> [CountryEntity] {
        let descriptor = FetchDescriptor<CountryEntity>()
        return try modelContext.fetch(descriptor)
    }
}

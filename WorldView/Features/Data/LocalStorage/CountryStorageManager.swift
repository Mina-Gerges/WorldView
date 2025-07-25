//
//  CountryStorageManager.swift
//  WorldView
//
//  Created by Mina Gerges on 24/07/2025.
//

import Foundation
import SwiftData

protocol CountryStorageManagerProtocol {
    func fetchSavedCountries() async throws -> [CountryEntity]
    func saveCountry(_ country: CountryEntity) async throws
    func deleteCountry(_ country: CountryEntity) async throws
}

@ModelActor
actor CountryStorageManager: CountryStorageManagerProtocol {
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

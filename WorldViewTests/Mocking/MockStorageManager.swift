//
//  MockStorageManager.swift
//  WorldView
//
//  Created by Mina Gerges on 25/07/2025.
//

import Testing
@testable import WorldView

actor MockStorageManager: CountryStorageManagerProtocol {
    private var savedCountries = [MockCountry.from(name: "France")]
    var shouldThrow = false
    
    func fetchSavedCountries() async throws -> [CountryEntity] {
        print("MockStorageManager.fetchSavedCountries was called")
        return savedCountries
    }
    
    func saveCountry(_ country: CountryEntity) async throws {
        savedCountries.append(country)
    }
    
    func deleteCountry(_ country: CountryEntity) async throws {
        savedCountries.removeAll { $0 == country }
    }
}

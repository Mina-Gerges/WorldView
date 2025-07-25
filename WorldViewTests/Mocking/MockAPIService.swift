//
//  MockAPIService.swift
//  WorldView
//
//  Created by Mina Gerges on 25/07/2025.
//

import Testing
@testable import WorldView
import Foundation

class MockAPIService: CountryAPIServiceProtocol {
    var allCountries: [CountryDTO] = []
    var searchResponse: [CountryDTO] = []
    var shouldThrow = false
    
    func fetchAllCountries() async throws -> [CountryDTO]? {
        if shouldThrow {
            throw URLError(.notConnectedToInternet)
        }
        return allCountries
    }
    
    func searchCountry(by name: String, fullText: Bool) async throws -> [CountryDTO]? {
        if shouldThrow {
            throw MockAPIError.simulatedError
        }
        return searchResponse
    }
}

enum MockAPIError: Error {
    case simulatedError
}

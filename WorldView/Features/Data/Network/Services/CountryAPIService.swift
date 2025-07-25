//
//  CountryAPIService.swift
//  WorldView
//
//  Created by Mina Gerges on 24/07/2025.
//

protocol CountryAPIServiceProtocol {
    func fetchAllCountries() async throws -> [CountryDTO]?
    func searchCountry(by name: String, fullText: Bool) async throws -> [CountryDTO]?
}

final class CountryAPIService: CountryAPIServiceProtocol {
    private let requestManager: RequestManagerProtocol

    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
    }
    
    func fetchAllCountries() async throws -> [CountryDTO]? {
        let request = APIRequests.fetchAllCountries
        let countries: [CountryDTO] = try await requestManager.perform(request)
        return countries
    }

    func searchCountry(by name: String, fullText: Bool = false) async throws -> [CountryDTO]? {
        let request = APIRequests.searchCountry(name: name, fullText: fullText)
        let countries: [CountryDTO] = try await requestManager.perform(request)
        return countries
    }
}

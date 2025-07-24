//
//  CountryAPIService.swift
//  WorldView
//
//  Created by Mina Gerges on 24/07/2025.
//

protocol CountryAPIService {
    func searchCountry(by name: String) async throws -> [CountryDTO]?
}

final class CountryAPIManager: CountryAPIService {
    private let requestManager: RequestManagerProtocol

    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
    }

    func searchCountry(by name: String) async throws -> [CountryDTO]? {
        let request = APIRequests.searchCountry(name: name)
        let countries: [CountryDTO] = try await requestManager.perform(request)
        return countries
    }
}

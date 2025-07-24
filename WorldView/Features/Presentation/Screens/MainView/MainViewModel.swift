//
//  MainViewModel.swift
//  WorldView
//
//  Created by Mina Gerges on 24/07/2025.
//

import Foundation
import Combine

@MainActor
final class MainViewModel: ObservableObject {
    // MARK: - Properties
    @Published var searchQuery = ""
    @Published var searchResults: [CountryEntity] = []
    @Published var selectedCountries: [CountryEntity] = []
    @Published var isLimitReached = false
    @Published var errorMessage: String?
    @Published var isSearching = false
    
    private var cancellables = Set<AnyCancellable>()
    private let apiService: CountryAPIServiceProtocol
    
    // MARK: - Init
    init() {
        apiService = CountryAPIService()
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                Task {
                    await self?.search(for: query)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    func search(for query: String) async {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        
        do {
            let dtos: [CountryDTO]? = try await apiService.searchCountry(by: query)
            let entities: [CountryEntity] = dtos?.map { CountryEntity.from(dto: $0) } ?? []
            searchResults = entities
            isSearching = false
        } catch {
            errorMessage = "Failed to fetch countries. Please check your connection."
            searchResults = []
            isSearching = false
        }
    }
    
    func addCountry(_ country: CountryEntity) {
        guard !selectedCountries.contains(country),
              selectedCountries.count < 5 else {
            isLimitReached = true
            return
        }
        
        selectedCountries.append(country)
        isLimitReached = false
    }
    
    func removeCountry(_ country: CountryEntity) {
        selectedCountries.removeAll { $0 == country }
    }
}


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
    private let locationManager = LocationManager.shared
    
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
        
        Task {
            await initializeWithCurrentLocation()
        }
    }
    
    // MARK: - Methods
    private func initializeWithCurrentLocation() async {
        guard let countryName = locationManager.country else { return }

        do {
            let dtos = try await apiService.searchCountry(by: countryName, fullText: true)
            if let dto = dtos?.first {
                let entity = CountryEntity.from(dto: dto)
                if !selectedCountries.contains(entity) {
                    selectedCountries.insert(entity, at: 0)
                }
            }
        } catch {
            print("Failed to fetch country for location: \(error)")
        }
    }
    
    func search(for query: String) async {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        
        do {
            let dtos: [CountryDTO]? = try await apiService.searchCountry(by: query, fullText: false)
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


//
//  MainViewModel.swift
//  WorldView
//
//  Created by Mina Gerges on 24/07/2025.
//

import Foundation
import Combine
import SwiftData

@MainActor
final class MainViewModel: ObservableObject {
    // MARK: - Properties
    @Published var searchQuery = "" {
        didSet {
            filterSearchResults(for: searchQuery)
        }
    }
    @Published var searchResults: [CountryEntity] = []
    @Published var selectedCountries: [CountryEntity] = [] {
        didSet {
            isLimitReached = selectedCountries.count >= 5
        }
    }
    @Published var isLimitReached = false
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    var allCountries: [CountryEntity] = []
    private var cancellables = Set<AnyCancellable>()
    private let apiService: CountryAPIServiceProtocol
    private let locationManager = LocationManager.shared
    private let storageManager: CountryStorageManagerProtocol
    
    // MARK: - Create ViewModel
    static func create() -> MainViewModel {
        do {
            let container = try ModelContainer(for: CountryEntity.self)
            return MainViewModel(modelContainer: container)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    // MARK: - Init
    init(
        modelContainer: ModelContainer,
        apiService: CountryAPIServiceProtocol = CountryAPIService(),
        storageManager: CountryStorageManagerProtocol? = nil
    ) {
        self.apiService = CountryAPIService()
        self.storageManager = storageManager ?? CountryStorageManager(modelContainer: modelContainer)
        Task {
            await initialize()
        }
    }
    
    // MARK: - Initial Methods
    func initialize() async {
        // Load persisted countries first, then fetch the current location country if counties less than 5.
        await loadPersistedCountries()
        
        if selectedCountries.count < 5 {
            _ = await (loadAllCountries(), initializeWithCurrentLocation())
        } else {
            // Already reached max, skip adding location
            await loadAllCountries()
        }
    }
    
    private func loadPersistedCountries() async {
        do {
            selectedCountries = try await storageManager.fetchSavedCountries()
        } catch {
            print("Failed to load saved countries: \(error)")
        }
    }
    
    private func initializeWithCurrentLocation() async {
        guard let countryName = locationManager.country else { return }

        do {
            let dtos = try await apiService.searchCountry(by: countryName, fullText: true)
            if let dto = dtos?.first {
                let entity = CountryEntity.from(dto: dto)
                if !selectedCountries.contains(where: { $0.name == entity.name }) {
                    addCountry(entity)
                }
            }
        } catch {
            print("Failed to fetch country for location: \(error)")
        }
    }
    
    private func loadAllCountries() async {
        isLoading = true
        do {
            let dtos = try await apiService.fetchAllCountries() ?? []
            allCountries = dtos.map { CountryEntity.from(dto: $0) }
            filterSearchResults(for: searchQuery)
            isLoading = false
        } catch {
            errorMessage = "Failed to fetch countries. Please check your connection."
            isLoading = false
        }
    }
    
    private func filterSearchResults(for query: String) {
        guard !query.isEmpty else {
            searchResults = allCountries
            return
        }

        let lowercasedQuery = query.lowercased()

        searchResults = allCountries.filter {
            ($0.name ?? "").lowercased().contains(lowercasedQuery) ||
            ($0.capital ?? "").lowercased().contains(lowercasedQuery)
        }
    }
    
    // MARK: - Other Methods
    
    func addCountry(_ country: CountryEntity) {
        guard !selectedCountries.contains(country),
              selectedCountries.count < 5 else {
            isLimitReached = true
            return
        }
        
        selectedCountries.append(country)
        
        Task {
            do {
                try await storageManager.saveCountry(country)
            } catch {
                print("Failed to save country: \(error)")
            }
        }
    }
    
    func removeCountry(_ country: CountryEntity) {
        selectedCountries.removeAll { $0 == country }
        
        Task {
            do {
                try await storageManager.deleteCountry(country)
            } catch {
                print("Failed to delete country: \(error)")
            }
        }
    }
}


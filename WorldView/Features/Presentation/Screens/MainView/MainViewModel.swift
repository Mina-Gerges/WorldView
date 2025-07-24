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
    @Published var searchQuery = ""
    @Published var searchResults: [CountryEntity] = []
    @Published var selectedCountries: [CountryEntity] = [] {
        didSet {
            if selectedCountries.count >= 5 {
                isLimitReached = true
            }
        }
    }
    @Published var isLimitReached = false
    @Published var errorMessage: String?
    @Published var isSearching = false
    @Published var selectedCountry: CountryEntity?
    @Published var isShowingDetail = false
    
    private var cancellables = Set<AnyCancellable>()
    private let apiService: CountryAPIServiceProtocol
    private let locationManager = LocationManager.shared
    private let storageManager: CountryStorageManager
    
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
    init(modelContainer: ModelContainer) {
        apiService = CountryAPIService()
        self.storageManager = CountryStorageManager(modelContainer: modelContainer)
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
            await initialize()
        }
    }
    
    // MARK: - Methods
    func initialize() async {
        // Load persisted countries first, then fetch the current location country if counties less than 5.
        await loadPersistedCountries()
        
        guard selectedCountries.count < 5 else {
            return // Already reached max, skip adding location
        }
        
        await initializeWithCurrentLocation()
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


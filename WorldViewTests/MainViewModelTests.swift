//
//  MainViewModelTests.swift
//  WorldView
//
//  Created by Mina Gerges on 25/07/2025.
//

import Testing
@testable import WorldView
import SwiftData

@Suite("MainViewModel Tests")
struct MainViewModelTests {

    // MARK: - Helper Method
    
    @MainActor static func makeSUT(
        api: CountryAPIServiceProtocol = MockAPIService(),
        storage: MockStorageManager = MockStorageManager()
    ) -> MainViewModel {
        let container = try! ModelContainer(for: CountryEntity.self)
        let vm = MainViewModel(modelContainer: container, apiService: api, storageManager: storage)
        return vm
    }

    // MARK: -  Test Suites
    
    @Suite("🔄 Initialize")
    struct Initialization {
        @MainActor @Test("Load persisted countries")
        func loadsSavedOnInit() async {
            let mockStorage = MockStorageManager()
            let vm = makeSUT(storage: mockStorage)

            try? await Task.sleep(nanoseconds: 200_000_000)

            #expect(vm.selectedCountries.first?.name == "France")
            #expect(vm.selectedCountries.count == 1)
        }
    }
    
    @Suite("🔍 Search")
    struct Search {
        @MainActor @Test("Query filters countries by name")
        func searchFiltersByName() {
            let vm = makeSUT()
            let egypt = MockCountry.from(name: "Egypt")
            let france = MockCountry.from(name: "France")

            vm.allCountries = [egypt, france]
            vm.searchQuery = "fra"

            #expect(vm.searchResults == [france])
        }

        @MainActor @Test("Empty query returns all")
        func emptyQueryShowsAll() {
            let vm = makeSUT()
            let c1 = MockCountry.from(name: "India")
            let c2 = MockCountry.from(name: "Brazil")

            vm.allCountries = [c1, c2]
            vm.searchQuery = ""

            #expect(vm.searchResults == [c1, c2])
        }
        
        @MainActor @Test("No results for unmatched query")
        func noResultsForUnmatchedQuery() {
            let vm = makeSUT()
            let egypt = MockCountry.from(name: "Egypt")
            let france = MockCountry.from(name: "France")

            vm.allCountries = [egypt, france]
            vm.searchQuery = "xyz"

            #expect(vm.searchResults.isEmpty)
        }
    }

    @Suite("✅ Selection")
    struct Selection {
        @MainActor @Test("Add country within limit")
        func addCountryIfNotFull() {
            let vm = makeSUT()
            let japan = MockCountry.from(name: "Japan")

            vm.addCountry(japan)

            #expect(vm.selectedCountries.contains(japan))
        }

        @MainActor @Test("Do not add country if limit reached")
        func preventAddIfFull() {
            let vm = makeSUT()
            for i in 1...5 {
                vm.selectedCountries.append(MockCountry.from(name: "C\(i)"))
            }
            let extra = MockCountry.from(name: "Extra")

            vm.addCountry(extra)

            #expect(!vm.selectedCountries.contains(extra))
            #expect(vm.isLimitReached == true)
        }

        @MainActor @Test("Remove selected country")
        func removeSelected() {
            let vm = makeSUT()
            let uk = MockCountry.from(name: "UK")
            vm.selectedCountries = [uk]

            vm.removeCountry(uk)

            #expect(!vm.selectedCountries.contains(uk))
        }
    }
}


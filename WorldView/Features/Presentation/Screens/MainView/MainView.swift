//
//  ContentView.swift
//  WorldView
//
//  Created by Mina Gerges on 23/07/2025.
//

import SwiftUI
import SwiftData

struct MainView: View {
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = MainViewModel.create()
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search countries...", text: $viewModel.searchQuery)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .padding(.horizontal)
                
                List {
                    // Section: Search Results
                    if viewModel.isSearching {
                        ProgressView("Searching...")
                    } else if let error = viewModel.errorMessage {
                        Section {
                            Text(error)
                                .foregroundColor(.red)
                        }
                    } else if !viewModel.searchResults.isEmpty {
                        Section(header: Text("Search Results")) {
                            ForEach(viewModel.searchResults) { country in
                                let isSelected = viewModel.selectedCountries.contains(where: { $0.name == country.name })
                                
                                CountryRowView(
                                    country: country,
                                    actionIcon: isSelected ? "checkmark.circle.fill" : "plus.circle",
                                    actionColor: isSelected ? .green : .blue,
                                    action: {
                                        if !isSelected {
                                            viewModel.addCountry(country)
                                        }
                                    },
                                    isDisabled: isSelected || viewModel.selectedCountries.count >= 5
                                )
                            }
                        }
                    } else if !viewModel.searchQuery.isEmpty {
                        Section {
                            Text("No countries found.")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Section: Selected Countries
                    if !viewModel.selectedCountries.isEmpty {
                        Section(header: Text("Selected Countries")) {
                            ForEach(viewModel.selectedCountries) { country in
                                NavigationLink(destination: CountryDetailView(country: country)) {
                                    CountryRowView(
                                        country: country,
                                        actionIcon: "trash",
                                        actionColor: .red,
                                        action: { viewModel.removeCountry(country) },
                                        isDisabled: false
                                    )
                                }
                            }
                        }
                    }
                    
                    if viewModel.isLimitReached {
                        Text("You can only add up to 5 countries.")
                            .foregroundColor(.red)
                    }
                }
                .listStyle(.insetGrouped)


            }
            .navigationTitle("Country Tracker")
        }
    }
}


#Preview {
    MainView()
        .modelContainer(for: CountryEntity.self, inMemory: true)
}

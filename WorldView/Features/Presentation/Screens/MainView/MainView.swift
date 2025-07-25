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
            VStack(spacing: 0) {
                TextField("Search countries...", text: $viewModel.searchQuery)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .padding(.horizontal)
                
                // Selected countries always visible
                if !viewModel.selectedCountries.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                            Text("Selected Countries")
                                .font(.headline)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                        
                        ForEach(viewModel.selectedCountries) { country in
                            NavigationLink(destination: CountryDetailView(country: country)) {
                                CountryRowView(
                                    country: country,
                                    actionIcon: "trash",
                                    actionColor: .red,
                                    action: { viewModel.removeCountry(country) },
                                    isDisabled: false
                                )
                                .padding(.horizontal)
                                .padding(.bottom, 10)
                            }
                        }
                    }
                    .padding(.top, 8)
                }
                
                if viewModel.isLimitReached {
                    Text("You can only add up to 5 countries.")
                        .foregroundColor(.red)
                        .padding()
                }
                
                Divider()
                
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.blue)
                    Text("Countries Search Results")
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical)
                
                // Scrollable Search Results
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        if viewModel.isLoading {
                            ProgressView("Searching...")
                                .padding()
                        } else if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .padding()
                        } else if !viewModel.searchResults.isEmpty {
                            
                            ForEach(viewModel.searchResults) { country in
                                NavigationLink(destination: CountryDetailView(country: country)) {
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
                                    .padding(.horizontal)
                                    .padding(.bottom, 10)
                                }
                            }
                        } else if !viewModel.searchQuery.isEmpty {
                            Text("No countries found.")
                                .foregroundColor(.gray)
                                .padding(.leading)
                        }
                    }
                }
            }
            .navigationTitle("World View")
        }
    }
    
}


#Preview {
    MainView()
        .modelContainer(for: CountryEntity.self, inMemory: true)
}

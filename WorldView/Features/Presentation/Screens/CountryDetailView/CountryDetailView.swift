//
//  CountryDetailView.swift
//  WorldView
//
//  Created by Mina Gerges on 24/07/2025.
//

import SwiftUI

struct CountryDetailView: View {
    // MARK: - Properties
    let country: CountryEntity

    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            Text(country.name ?? "")
                .font(.largeTitle)
                .bold()
            
            AsyncImage(url: URL(string: country.flag ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 160, height: 120)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 160)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                case .failure:
                    Image(systemName: "flag.slash")
                        .resizable()
                        .aspectRatio(4/3, contentMode: .fit)
                        .frame(maxWidth: 160)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Capital:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text((country.capital?.isEmpty ?? true) ? "N/A" : country.capital ?? "")
                }

                HStack {
                    Text("Currency:")
                        .fontWeight(.semibold)
                    Spacer()
                    if let currency = country.currency,
                       let name = currency.name,
                       let code = currency.code,
                       let symbol = currency.symbol,
                       !name.isEmpty, !code.isEmpty, !symbol.isEmpty {
                        Text("\(name) (\(code)) - \(symbol)")
                    } else {
                        Text("N/A")
                    }
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding()

            Spacer()
        }
        .navigationTitle("Country Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CountryDetailView(
        country: CountryEntity(
            name: "Egypt",
            flag: "",
            capital: "Cairo",
            currency: CurrencyInfoEntity(code: "", name: "EGP", symbol: "")
        )
    )
}

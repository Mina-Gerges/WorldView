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
            
            CachedAsyncImage(
                url: URL(string: country.flag ?? ""),
                placeholder: {
                    AnyView(ProgressView().frame(width: 160, height: 120))
                },
                image: { img in
                    AnyView(
                        img
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 160)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                    )
                }
            )

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

//
//  CountryRowView.swift
//  WorldView
//
//  Created by Mina Gerges on 24/07/2025.
//

import SwiftUI

struct CountryRowView: View {
    let country: CountryEntity
    let actionIcon: String
    let actionColor: Color
    let action: () -> Void
    let isDisabled: Bool

    var body: some View {
        HStack {
            CachedAsyncImage(
                url: URL(string: country.flag ?? ""),
                placeholder: {
                    AnyView(ProgressView().frame(width: 40, height: 30))
                },
                image: { img in
                    AnyView(
                        img
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 30)
                            .cornerRadius(4)
                    )
                }
            )

            VStack(alignment: .leading) {
                Text(country.name ?? "Unknown")
                    .font(.headline)
                if let capital = country.capital {
                    Text("Capital: \(capital)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Button(action: action) {
                Image(systemName: actionIcon)
                    .foregroundColor(actionColor)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(isDisabled)
        }
    }
}

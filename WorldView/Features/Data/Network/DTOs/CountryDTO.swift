//
//  CountryDTO.swift
//  WorldView
//
//  Created by Mina Gerges on 24/07/2025.
//

import Foundation

struct CountryDTO: Decodable {
    let name: Name
    let capital: [String]?
    let flags: Flags
    let currencies: [String]

    struct Name: Decodable {
        let common: String
    }

    struct Flags: Decodable {
        let svg: String?
        let png: String?
    }

    struct CurrencyInfo: Decodable {
        let name: String
    }

    private enum CodingKeys: String, CodingKey {
        case name, capital, flags, currencies
    }

    private struct DynamicCurrenciesCodingKey: CodingKey {
        var stringValue: String
        var intValue: Int? { nil }

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            return nil
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(Name.self, forKey: .name)
        capital = try container.decodeIfPresent([String].self, forKey: .capital)
        flags = try container.decode(Flags.self, forKey: .flags)

        let currencyContainer = try container.nestedContainer(keyedBy: DynamicCurrenciesCodingKey.self, forKey: .currencies)
        currencies = try currencyContainer.allKeys.compactMap { key in
            try currencyContainer.decode(CurrencyInfo.self, forKey: key).name
        }
    }
}


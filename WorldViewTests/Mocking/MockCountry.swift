//
//  MockCountry.swift
//  WorldView
//
//  Created by Mina Gerges on 25/07/2025.
//

import Testing
@testable import WorldView

struct MockCountry: Equatable {
    let name: String
    let capital: String?
    
    static func from(name: String, capital: String? = nil) -> CountryEntity {
        let country = CountryEntity()
        country.name = name
        country.capital = capital
        return country
    }
}

//
//  Item.swift
//  WorldView
//
//  Created by Mina Gerges on 23/07/2025.
//

import Foundation
import SwiftData

@Model
class CountryEntity {
    var name: String
    var flag: String
    var capital: String
    var currency: String
    
    init(name: String, flag: String, capital: String, currency: String) {
        self.name = name
        self.flag = flag
        self.capital = capital
        self.currency = currency
    }
}

extension CountryEntity {
    static func from(dto: CountryDTO) -> CountryEntity {
        CountryEntity(
            name: dto.name.common,
            flag: dto.flags.png ?? dto.flags.svg ?? "N/A",
            capital: dto.capital?.first ?? "N/A",
            currency: dto.currencies.first ?? "N/A"
        )
    }
}

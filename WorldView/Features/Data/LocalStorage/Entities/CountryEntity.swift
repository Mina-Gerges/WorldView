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
    var name: String?
    var flag: String?
    var capital: String?
    var currency: CurrencyInfoEntity?
    
    init(name: String? = nil, flag: String? = nil, capital: String? = nil, currency: CurrencyInfoEntity? = nil) {
        self.name = name
        self.flag = flag
        self.capital = capital
        self.currency = currency
    }
}

extension CountryEntity {
    static func from(dto: CountryDTO) -> CountryEntity {
        let currencyEntity: CurrencyInfoEntity? = dto.currencies?.first.map {
            CurrencyInfoEntity(code: $0.code, name: $0.name, symbol: $0.symbol)
        }
        
        return CountryEntity(
            name: dto.name,
            flag: dto.flags?.png ?? dto.flag,
            capital: dto.capital,
            currency: currencyEntity
        )
    }
}

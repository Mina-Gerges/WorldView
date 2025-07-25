//
//  CountryDTO.swift
//  WorldView
//
//  Created by Mina Gerges on 24/07/2025.
//

import Foundation

struct CountryDTO: Decodable {
    let name: String?
    let capital: String?
    let flag: String?
    let flags: Flags?
    let currencies: [CurrencyInfo]?
    let timezones: [String]?
    let languages: [LanguageInfo]?

    struct Flags: Decodable {
        let svg: String?
        let png: String?
    }

    struct CurrencyInfo: Decodable {
        let code: String?
        let name: String?
        let symbol: String?
    }

    struct LanguageInfo: Decodable {
        let name: String?
        let nativeName: String?
    }
}



//
//  APIRequests.swift
//  WorldView
//
//  Created by Mina Gerges on 24/07/2025.
//

import Foundation

enum APIRequests: RequestProtocol {
    case fetchAllCountries
    case searchCountry(name: String, fullText: Bool)

    var host: String {
        return "restcountries.com"
    }

    var path: String {
        switch self {
        case .fetchAllCountries:
            return "/v2/all"
        case .searchCountry(let name, _):
            return "/v2/name/\(name)"
        }
    }

    var requestType: RequestType {
        return .GET
    }

    var urlParams: [String: String?] {
        switch self {
        case .fetchAllCountries:
            return ["fields": "name,capital,currencies,flag,flags"]
        case .searchCountry(_, let fullText):
            return ["fullText": fullText ? "true" : nil]
        }
    }

    var headers: [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    }
}


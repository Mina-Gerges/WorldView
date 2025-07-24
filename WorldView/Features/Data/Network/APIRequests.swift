//
//  APIRequests.swift
//  WorldView
//
//  Created by Mina Gerges on 24/07/2025.
//

import Foundation

enum APIRequests: RequestProtocol {
    case searchCountry(name: String, fullText: Bool)

    var host: String {
        return "restcountries.com"
    }

    var path: String {
        switch self {
        case .searchCountry(let name, _):
            return "/v2/name/\(name)"
        }
    }

    var requestType: RequestType {
        return .GET
    }

    var urlParams: [String: String?] {
        switch self {
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


//
//  APIRequests.swift
//  WorldView
//
//  Created by Mina Gerges on 24/07/2025.
//

import Foundation

enum APIRequests: RequestProtocol {
    case searchCountry(name: String)

    var host: String {
        return "restcountries.com/v2"
    }

    var path: String {
        switch self {
        case .searchCountry(let name):
            return "/name/\(name)"
        }
    }

    var requestType: RequestType {
        return .GET
    }

    var urlParams: [String: String?] {
        return [:]
    }

    var headers: [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    }
}


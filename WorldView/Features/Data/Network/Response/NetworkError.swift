//
//  NetworkError.swift
//  WorldView
//
//  Created by Mina Gerges on 23/07/2025.
//

import Foundation

/// It's holding all different network related errors with their corresponding description
enum NetworkError: LocalizedError {
    case network
    case invalidURL
    case invalidServerResponse
    public var errorDescription: String? {
        switch self {
        case .network:
            return ErrorMessages.networkError
        case .invalidURL:
            return ErrorMessages.invalidURL
        case .invalidServerResponse:
            return ErrorMessages.invalidServerResponse
        }
    }
}

//
//  ParsingError.swift
//  WorldView
//
//  Created by Mina Gerges on 23/07/2025.
//

import Foundation

enum ParsingError: Error, LocalizedError {
    case decodingError(DecodingError)
    case dataCorrupted(description: String)
    case unknownError(description: String)
    
    var errorDescription: String? {
        switch self {
        case .decodingError(let error):
            return ErrorMessages.decodingFailed + "\(error.localizedDescription)"
        case .dataCorrupted(let description):
            return ErrorMessages.dataCorrupted + "\(description)"
        case .unknownError(let description):
            return ErrorMessages.unknownError + "\(description)"
        }
    }
}

//
//  ErrorMessages.swift
//  WorldView
//
//  Created by Mina Gerges on 23/07/2025.
//

import Foundation

enum ErrorMessages {
    // Network Errors
    static let networkError = "Please Check your internet connection."
    static let invalidURL = "URL string is malformed."
    static let invalidServerResponse = "Something went wrong. Please try again later."
    
    // Decoding Errors
    static let decodingFailed = "Decoding failed: "
    static let dataCorrupted = "Data is corrupted: "
    static let unknownError = "Unknown error: "
}

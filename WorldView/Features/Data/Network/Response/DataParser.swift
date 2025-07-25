//
//  DataParser.swift
//  WorldView
//
//  Created by Mina Gerges on 23/07/2025.
//

import Foundation

public protocol DataParserProtocol {
    func parse<T: Decodable>(data: Data) throws -> T
}

/// DataParser responsible for parsing response coming from network.
public class DataParser: DataParserProtocol {
    private var jsonDecoder: JSONDecoder
    
    public init(jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale(identifier: "en-US")
        self.jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    public func parse<T: Decodable>(data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            // Catch specific decoding errors
            switch decodingError {
            case .typeMismatch(let type, let context):
                throw ParsingError.decodingError(
                    .typeMismatch(type, context)
                )
            case .valueNotFound(let type, let context):
                throw ParsingError.decodingError(
                    .valueNotFound(type, context)
                )
            case .keyNotFound(let key, let context):
                throw ParsingError.decodingError(
                    .keyNotFound(key, context)
                )
            case .dataCorrupted(let context):
                throw ParsingError.dataCorrupted(
                    description: context.debugDescription
                )
            @unknown default:
                throw ParsingError.unknownError(
                    description: "Unknown decoding error."
                )
            }
        } catch {
            throw ParsingError.unknownError(
                description: error.localizedDescription
            )
        }
    }
}

//
//  APIManager.swift
//  WorldView
//
//  Created by Mina Gerges on 23/07/2025.
//

import Foundation

public protocol APIManagerProtocol {
    var parser: DataParserProtocol { get set }
    func perform(_ request: RequestProtocol) async throws -> Data
}

/// The manager responsible for performing the actual calling and handling error messages.
public class APIManager: NSObject, APIManagerProtocol {
    private let urlSession: URLSession
    public var parser: DataParserProtocol

    public init(urlSession: URLSession = URLSession.shared, parser: DataParserProtocol) {
        self.urlSession = urlSession
        self.parser = parser
    }

    public func perform(_ request: RequestProtocol) async throws -> Data {
        let (data, response) = try await urlSession.data(for: request.createURLRequest())
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else { throw NetworkError.invalidServerResponse }
        return data
    }
}

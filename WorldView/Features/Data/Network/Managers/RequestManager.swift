//
//  RequestManager.swift
//  WorldView
//
//  Created by Mina Gerges on 23/07/2025.
//

import Foundation

public protocol RequestManagerProtocol {
    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T
}

/// The manager responsible for preparing the URL Session, performing the requests and parsing the data.
public class RequestManager: RequestManagerProtocol {
    let apiManager: APIManagerProtocol
    let parser: DataParserProtocol
    
    public init() {
        self.parser = DataParser()
        self.apiManager = APIManager(urlSession: RequestManager.getUrlSession(), parser: parser)
    }
    
    private static func getUrlSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 90
        configuration.timeoutIntervalForResource = 90
        configuration.httpMaximumConnectionsPerHost = 10
        configuration.httpMaximumConnectionsPerHost = 6
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration)
    }
    
    public func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T {
        let data = try await apiManager.perform(request)
        let decoded: T = try parser.parse(data: data)
        return decoded
    }
}

public struct EmptyResponseModel: Codable {
    public init() { }
}

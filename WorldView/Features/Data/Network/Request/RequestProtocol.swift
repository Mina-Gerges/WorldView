//
//  RequestProtocol.swift
//  WorldView
//
//  Created by Mina Gerges on 23/07/2025.
//

import Foundation

public enum RequestContentType {
    case xFormWUrl
    case json
    case multipartFormData
}

public protocol RequestProtocol {
    var host: String { get }
    var path: String { get }
    var requestType: RequestType { get }
    var headers: [String: String] { get }
    var params: [String: Any] { get }
    var urlParams: [String: String?] { get }
    var addAuthorizationToken: Bool { get }
    var requestContentType: RequestContentType { get }
    var multipartFormData: Data? { get }
}

// MARK: - Default RequestProtocol
public extension RequestProtocol {
    var host: String {
        ""
    }
    
    var addAuthorizationToken: Bool {
        false
    }
    
    var params: [String: Any] {
        [:]
    }
    
    var urlParams: [String: String?] {
        [:]
    }
    
    var headers: [String: String] {
        [:]
    }
    
    var requestContentType: RequestContentType {
        .json
    }
    
    var multipartFormData: Data? {
        nil
    }
    
    func createURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        
        if !urlParams.isEmpty {
            components.queryItems = urlParams.map { URLQueryItem(name: $0, value: $1) }
        }
        
        guard let url = components.url else { throw  NetworkError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue
        
        if !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        switch requestContentType {
        case .json:
            if !params.isEmpty {
                let body = try JSONSerialization.data(withJSONObject: params)
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = body
            }
        case .xFormWUrl:
            if !params.isEmpty {
                var body: Data?
                var data = params.reduce("") { partialResult, element in
                    return partialResult + "\(element.key)=\(element.value)&"
                }
                data.removeLast()
                body = data.data(using: .utf8)
                urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = body
            }
        case .multipartFormData:
            if let body = multipartFormData {
                urlRequest.setValue("multipart/form-data; boundary=\(UUID().uuidString)", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = body
            }
        }
        return urlRequest
    }
}

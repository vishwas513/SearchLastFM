//
//  APIRequest.swift
//  LastFmSearch
//
//  Created by Vishwas Mukund on 9/14/19.
//  Copyright © 2019 Vishwas Mukund. All rights reserved.
//

import UIKit

final class APIRequest {
    // MARK: - Public properties
    let method: HTTPMethod
    let path: String
    private(set) var queryItems: [URLQueryItem]?
    private(set) var headers: [HTTPHeader]?
    var body: Data?
    
    // MARK: - Private Properties
    private let formURLEncodedAllowedCharacters: CharacterSet = {
        typealias c = UnicodeScalar
        
        // https://url.spec.whatwg.org/#urlencoded-serializing
        var allowed = CharacterSet()
        allowed.insert(c(0x2A))
        allowed.insert(charactersIn: c(0x2D)...c(0x2E))
        allowed.insert(charactersIn: c(0x30)...c(0x39))
        allowed.insert(charactersIn: c(0x41)...c(0x5A))
        allowed.insert(c(0x5F))
        allowed.insert(charactersIn: c(0x61)...c(0x7A))
        
        // and we'll deal with ` ` later…
        allowed.insert(" ")
        
        return allowed
    }()
    
    // MARK: - Initializers
    init(method: HTTPMethod, path: String) {
        self.method = method
        self.path = path
    }
    
    init<Body: Encodable>(method: HTTPMethod, path: String, body: Body) throws {
        self.method = method
        self.path = path
        self.body = try JSONEncoder().encode(body)
    }
    
    // MARK: - Helper methods
    func encode(params: [String: String]) {
        guard let headers = headers else { return }
        
        if let contentType = headers.compactMap({ $0 as? ContentType }).first,
            contentType.value == ContentType.MediaType.formURLEncoded.rawValue {
            queryItems = params.map { (key, value) in
                return URLQueryItem(name: key,
                                    value: (value.addingPercentEncoding(withAllowedCharacters: formURLEncodedAllowedCharacters) ?? "")
                                        .replacingOccurrences(of: " ", with: "+"))
            }
        } else {
            queryItems = params.map { (key, value) in
                return URLQueryItem(name: key, value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
            }
        }
    }
    
    func add(_ header: HTTPHeader) {
        if headers != nil {
            headers?.append(header)
        } else {
           // headers = [APIGatewayAuthorization(marketingAPIKey), header]
        }
    }
}

// MARK: - Convenience Static Methods
extension APIRequest {
    static func get(withPath path: String) -> Self {
        return self.init(method: .get, path: path)
    }
    
    static func post(withPath path: String) -> Self {
        return self.init(method: .post, path: path)
    }
    
    static func put(withPath path: String) -> Self {
        return self.init(method: .put, path: path)
    }
    
    static func delete(withPath path: String) -> Self {
        return self.init(method: .delete, path: path)
    }
}


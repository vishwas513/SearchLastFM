//
//  HTTPHeader.swift
//  LastFmSearch
//
//  Created by Vishwas Mukund on 9/14/19.
//  Copyright © 2019 Vishwas Mukund. All rights reserved.
//

import Foundation

protocol HTTPHeader {
    var key: String { get }
    var value: String { get }
}

struct ContentType: HTTPHeader {
    // MARK: - MediaType
    enum MediaType: String {
        case json = "application/json"
        case jsonPatch = "application/json-patch+json"
        case formURLEncoded = "application/x-www-form-urlencoded"
    }
    // MARK: - Public Properties
    let key: String = "Content-Type"
    let value: String
    
    // MARK: - Initializer
    init(_ mediaType: MediaType) {
        self.value = mediaType.rawValue
    }
}

struct Authorization: HTTPHeader {
    let key: String = "Authorization"
    let value: String
    
    init(accessToken: String) {
        self.value = "Bearer \(accessToken)"
    }
}

struct APIGatewayAuthorization: HTTPHeader {
    let key: String = "Ocp-Apim-Subscription-Key"
    let value: String
    
    init(_ gatewayKey: String) {
        self.value = gatewayKey
    }
}


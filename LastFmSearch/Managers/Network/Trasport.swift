//
//  Trasport.swift
//  LastFmSearch
//
//  Created by Vishwas Mukund on 9/14/19.
//  Copyright © 2019 Vishwas Mukund. All rights reserved.
//

import Foundation

// MARK: - Transport
protocol Transport {
    // MARK: Properties
    var backgroundSessionCompletionHandler: (() -> Void)? { get set }
    // MARK: - Methods
    init(baseURL: URL)
    func get(_ request: APIRequest, completion: @escaping NetworkResult) -> URLSessionDataTask
    func post(_ request: APIRequest, completion: @escaping NetworkResult) -> URLSessionUploadTask
    func delete(_ request: APIRequest, completion: @escaping NetworkResult) -> URLSessionDataTask
    func getImage(for url: URL, completion: @escaping ImageResult) -> URLSessionDownloadTask
    func getImage(urlString: String, completion: @escaping ImageResult)
}

//
//  NetworkManager.swift
//  LastFmSearch
//
//  Created by Vishwas Mukund on 9/14/19.
//  Copyright © 2019 Vishwas Mukund. All rights reserved.
//

import UIKit
import os.log

extension NSError {
    convenience init(code: Int) {
        self.init(domain: Bundle.main.bundleIdentifier ?? "", code: code, userInfo: nil)
    }
}

enum NetworkError: Error {
    case constructingURLFailed
    case noDataReturned
    case decodingDataFailed
    case encodingBodyFailed
    case badURL
    case noNetworkResponse
    case network(Error)
    case dataTaskError(nsError: NSError)
    case tokenRequired
    case imageData
    case emptyResponse
    case unauthorized
    
    init?(dataTaskError: Error?) {
        if let error = dataTaskError {
            self = .dataTaskError(nsError: error as NSError)
        } else {
            return nil
        }
    }
}

// MARK: - Completion Handlers
typealias NetworkResult = (Result<(headers: HTTPURLResponse, body: Data), NetworkError>) -> Void
typealias ImageResult = (Result<UIImage?, NetworkError>) -> Void

// MARK: - NetworkManager
final class NetworkManager: NSObject, Transport {
    // MARK: - Private Properties
    private var urlSession: URLSession
    private var backgroundSession: URLSession!
    private var completionHandlers = [URL: ImageResult]()
    private var networkActivityCount: Int = 0 {
        didSet {
            #if os(iOS)
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = (self.networkActivityCount > 0)
            }
            #endif
        }
    }
    
    private lazy var logger: OSLog = {
        let logger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "NetworkManager")
        
        return logger
    }()
    
    // MARK: - Public Properties
    private var baseURL: URL
    /// You need to set this in completion handler in the method
    /// **application handleEventsForBackgroundURLSession identifier: completionHandler:**
    var backgroundSessionCompletionHandler: (() -> Void)?
    
    // MARK: - Initializer
    init(baseURL: URL) {
        // Creating session configuration
        let configuration = URLSessionConfiguration.default
        // Creating Operation Queue
        let queue = OperationQueue()
        queue.qualityOfService = .background
        // Creating URL Session
        urlSession = URLSession(configuration: configuration, delegate: nil, delegateQueue: queue)
        self.baseURL = baseURL
        super.init()
        guard let backgroundSessionIdentifier = Bundle.main.infoDictionary?["BackgroundSessionIdentifier"] as? String else {
            fatalError("BackgroundSessionIdentifier not found in your info.plist")
        }
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: backgroundSessionIdentifier)
        
        backgroundSession = URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: nil)
    }
    
    func get(_ request: APIRequest, completion: @escaping NetworkResult) -> URLSessionDataTask {
        // We display the network activity indicator on devices different than iPhone X, Xs, Xs Max and Xr
        OperationQueue.main.addOperation {
            self.networkActivityCount += 1
        }
        
        let request = createURLRequest(forRequest: request)
        
        let task = dataTask(request, completion: completion)
        return task
    }
    
    func post(_ apiRequest: APIRequest, completion: @escaping NetworkResult) -> URLSessionUploadTask {
        // We display the network activity indicator on devices different than iPhone X, Xs, Xs Max and Xr
        OperationQueue.main.addOperation {
            self.networkActivityCount += 1
        }
        
        let request = createURLRequest(forRequest: apiRequest)
        let task = uploadTask(request, body: apiRequest.body, completion: completion)
        return task
    }
    
    func delete(_ apiRequest: APIRequest, completion: @escaping NetworkResult) -> URLSessionDataTask {
        // We display the network activity indicator on devices different than iPhone X, Xs, Xs Max and Xr
        OperationQueue.main.addOperation {
            self.networkActivityCount += 1
        }
        
        let request = createURLRequest(forRequest: apiRequest)
        let task = dataTask(request, completion: completion)
        return task
    }
    
    func getImage(for url: URL, completion: @escaping ImageResult) -> URLSessionDownloadTask {
        let request = URLRequest(url: url)
        OperationQueue.main.addOperation {
            self.networkActivityCount += 1
        }
        let task = urlSession.downloadTask(with: request, completionHandler: { (fileURL, _, error) in
            guard let fileURL = fileURL else {
                guard let error = error else { return }
                OperationQueue.main.addOperation {
                    self.networkActivityCount -= 1
                    completion(.failure(.network(error)))
                }
                return
            }
            
            // You must move the file or open it for reading before this closure returns or it will be deleted
            if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
                OperationQueue.main.addOperation {
                    self.networkActivityCount -= 1
                    completion(.success(image))
                }
            } else {
                OperationQueue.main.addOperation {
                    self.networkActivityCount -= 1
                    completion(.failure(.imageData))
                }
            }
        })
        
        task.resume()
        return task
    }
    
    func getImage(urlString: String, completion: @escaping ImageResult) {
        guard let sanitizedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: sanitizedURLString) else {
            completion(.failure(.badURL))
            return
        }
        
        _ = getImage(for: url, completion: completion)
    }
}

// MARK: - Private helpers
private extension NetworkManager {
    func dataTask(_ request: URLRequest, completion: @escaping NetworkResult) -> URLSessionDataTask {
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse else {
                if let error = error {
                    OperationQueue.main.addOperation {
                        self.networkActivityCount -= 1
                    }
                    
                    completion(.failure(.network(error)))
                } else {
                    OperationQueue.main.addOperation {
                        self.networkActivityCount -= 1
                    }
                    
                    completion(.failure(.emptyResponse))
                }
                
                return
            }
            
            OperationQueue.main.addOperation {
                self.networkActivityCount -= 1
            }
            
            completion(.success((response, data)))
        }
        
        task.resume()
        return task
    }
    
    func uploadTask(_ request: URLRequest, body: Data?, completion: @escaping NetworkResult) -> URLSessionUploadTask {
        let task = urlSession.uploadTask(with: request, from: body) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse else {
                if let error = error {
                    OperationQueue.main.addOperation {
                        self.networkActivityCount -= 1
                    }
                    completion(.failure(.network(error)))
                } else {
                    OperationQueue.main.addOperation {
                        self.networkActivityCount -= 1
                    }
                    completion(.failure(.emptyResponse))
                }
                return
            }
            
            OperationQueue.main.addOperation {
                self.networkActivityCount -= 1
            }
            
            completion(.success((response, data)))
        }
        
        task.resume()
        return task
    }
    
    func createURLRequest(forRequest apiRequest: APIRequest) -> URLRequest {
        guard let url = URL(string: apiRequest.path, relativeTo: baseURL) else {
            os_log("Unable to create URL using path: %@", log: logger, type: .error, apiRequest.path)
            assertionFailure("\(#file): \(#line)")
            // This should never be reached
            return URLRequest(url: baseURL)
        }
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        // If we have params to pass in the url
        if let queryItems = apiRequest.queryItems {
            urlComponents?.queryItems = queryItems
            if apiRequest.method == .post {
                let query = urlComponents?.query
                urlComponents?.queryItems = nil
                apiRequest.body = query?.data(using: .utf8, allowLossyConversion: true)
            }
        }
        
        var request = URLRequest(url: (urlComponents?.url)!)
        
        if let headers = apiRequest.headers {
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        os_log("Requested URL: %@", log: logger, type: .info, request.url!.absoluteString)
        request.httpMethod = apiRequest.method.rawValue
        
        
        return request
    }
}

// MARK: - URLSessionDelegate
extension NetworkManager: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error, let url = task.originalRequest?.url, let completion = completionHandlers[url] {
            completionHandlers[url] = nil
            OperationQueue.main.addOperation {
                self.networkActivityCount -= 1
                completion(.failure(.dataTaskError(nsError: error as NSError)))
            }
        }
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        if let completionHandler = backgroundSessionCompletionHandler {
            backgroundSessionCompletionHandler = nil
            OperationQueue.main.addOperation {
                completionHandler()
            }
        }
    }
}

// MARK: - URLSessionDownloadDelegate
extension NetworkManager: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // You must move the file or open it for reading before this closure returns or it will be deleted
        if let data = try? Data(contentsOf: location), let image = UIImage(data: data), let request = downloadTask.originalRequest, let response = downloadTask.response {
            let cachedResponse = CachedURLResponse(response: response, data: data)
            self.urlSession.configuration.urlCache?.storeCachedResponse(cachedResponse, for: request)
            if let url = downloadTask.originalRequest?.url, let completion = completionHandlers[url] {
                completionHandlers[url] = nil
                OperationQueue.main.addOperation {
                    self.networkActivityCount -= 1
                    completion(.success(image))
                }
            }
        } else {
            if let url = downloadTask.originalRequest?.url, let completion = completionHandlers[url] {
                completionHandlers[url] = nil
                OperationQueue.main.addOperation {
                    self.networkActivityCount -= 1
                    completion(.failure(.imageData))
                }
            }
        }
    }
}


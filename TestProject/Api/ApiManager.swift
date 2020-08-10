//
//  ApiManager.swift
//  TestProject
//
//  Created by Oleg on 05.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ApiManager {
    private let urlSession = URLSession(configuration: .default)
    private let apiPrefix = "https://precision.dev.thrive.io/v1"
    private let localRepo = LocalRepo()
    
    func getRequest<T: Decodable>(endpoint: String, authorized: Bool = false, parameters: [(String, String)]? = nil) -> Observable<(response: HTTPURLResponse, result: T)>? {
        var urlString = apiPrefix + endpoint
        
        if let params = parameters, params.count > 0 {
            urlString = urlString + "?"
            
            if let first = params.first {
                urlString = urlString + first.0 + "=" + first.1
            }
            
            for param in params.dropFirst() {
                urlString = urlString + "&" + param.0 + "=" + param.1
            }
        }
        
        guard let url = URL(string: urlString) else { return nil }
        
        let urlRequest = makeURLRequestWithHeader(url: url, method: .get, authorized: authorized)
        
        return response(request: urlRequest)
    }
    
    func postRequest<T: Decodable, PostObject: Encodable>(endpoint: String, toPost: PostObject, authorized: Bool = false) -> Observable<(response: HTTPURLResponse, result: T)>? {
        let urlString = apiPrefix + endpoint
        guard let url = URL(string: urlString) else { return nil }
        
        var urlRequest = makeURLRequestWithHeader(url: url, method: .get, authorized: authorized)
        
        guard let encodedData = try? JSONEncoder().encode(toPost) else { return nil }
        urlRequest.httpBody = encodedData
        
        return response(request: urlRequest)
    }
    
    func response<T: Decodable> (request: URLRequest) -> Observable<(response: HTTPURLResponse, result: T)> {
        return Observable.create { observer in
            let task = self.urlSession.dataTask(with: request) { (data, response, error) in

                guard let response = response, let data = data else {
                    observer.on(.error(error ?? RxCocoaURLError.unknown))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.on(.error(RxCocoaURLError.nonHTTPResponse(response: response)))
                    return
                }
                
                guard let decodedResult: T = try? JSONDecoder().decode(T.self, from: data) else { return }
                
                observer.on(.next((httpResponse, decodedResult)))
                observer.on(.completed)
            }

            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func makeURLRequestWithHeader(url: URL, method: HttpMethod, authorized: Bool = false) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        if authorized, let savedKey = localRepo.getEntity(token: "authorizationKey") as? SimpleEntity {
            urlRequest.addValue("Bearer " + savedKey.value, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

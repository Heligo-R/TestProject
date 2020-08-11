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
        guard let escapedString = urlString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) else { return nil }
        guard let url = URL(string: escapedString) else { return nil }
        
        let urlRequest = makeURLRequestWithHeader(url: url, method: .get, header: prepareHeader(authorized: authorized))
        
        return response(request: urlRequest)
    }
    
    func postRequest<T: Decodable, PostObject: Encodable>(endpoint: String, toPost: PostObject, authorized: Bool = false) -> Observable<(response: HTTPURLResponse, result: T)>? {
        let urlString = apiPrefix + endpoint
        guard let url = URL(string: urlString) else { return nil }
        
        var urlRequest = makeURLRequestWithHeader(url: url, method: .get, header: prepareHeader(authorized: authorized))
        
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
    
    private func prepareHeader(authorized: Bool = false) -> [(String, String)] {
        var httpHeaders: [(String, String)] = []
        if authorized, let savedKey = localRepo.getSimpleEntity(token: "authorizationKey") {
                   httpHeaders.append(("Authorization", "Bearer" + savedKey.value))
        }
        return httpHeaders
    }
    
    private func makeURLRequestWithHeader(url: URL, method: HttpMethod, header: [(String, String)]? = nil) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        if let headerValues = header, headerValues.count > 0 {
            for (key, value) in headerValues {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
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

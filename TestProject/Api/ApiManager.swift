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
    
    func makeGetRequest(url: URL) -> Observable<Data> {
        let urlRequest = makeURLRequestWithHeader(url: url, method: .get)
        return proceedResponse(request: urlRequest)
    }
    
    func makeGetRequest<T: Decodable>(endpoint: String, isAuthorized: Bool = false, parameters: [(String, String)]? = nil) -> Observable<T> {
        var urlString = apiPrefix + endpoint
        
        if let params = parameters, params.count > 0 {
            urlString = "\(urlString)?"
            
            if let first = params.first {
                urlString = "\(urlString)\(first.0)=\(first.1)"
            }
            
            for param in params.dropFirst() {
                urlString = "\(urlString)&\(param.0)=\(param.1)"
            }
        }
        guard let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return makeObservableError(.urlComposingError) }
        guard let url = URL(string: escapedString) else { return makeObservableError(.urlComposingError) }
        
        let urlRequest = makeURLRequestWithHeader(url: url, method: .get, header: prepareHeader(isAuthorized: isAuthorized))
        
        return proceedResponse(request: urlRequest)
    }
    
    func makePostRequest<T: Decodable, PostObject: Encodable>(endpoint: String, toPost: PostObject, isAuthorized: Bool = false) -> Observable<T> {
        let urlString = apiPrefix + endpoint
        guard let url = URL(string: urlString) else { return makeObservableError(.urlComposingError) }
        
        var urlRequest = makeURLRequestWithHeader(url: url, method: .post, header: prepareHeader(isAuthorized: isAuthorized, isJson: true))
        
        guard let encodedData = try? JSONEncoder().encode(toPost) else { return makeObservableError(.jsonEncodingError) }
        urlRequest.httpBody = encodedData
        
        return proceedResponse(request: urlRequest)
    }
    
    func proceedResponse<T: Decodable> (request: URLRequest) -> Observable<T> {
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
                
                if httpResponse.statusCode != 200 {
                    guard let decodedError: ErrorMessage = try? JSONDecoder().decode(ErrorMessage.self, from: data) else {
                        observer.on(.error(ErrorMessages.jsonEncodingError))
                        return
                    }
                    observer.on(.error(decodedError))
                    return
                }
                
                guard let decodedResult: T = try? JSONDecoder().decode(T.self, from: data) else {
                    observer.on(.error(ErrorMessages.jsonEncodingError))
                    return
                }
                
                observer.on(.next(decodedResult))
                observer.on(.completed)
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func proceedResponse(request: URLRequest) -> Observable<Data> {
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
                
                if httpResponse.statusCode != 200 {
                    observer.on(.error(ErrorMessages.httpError))
                    return
                }
                
                observer.on(.next(data))
                observer.on(.completed)
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    private func makeObservableError<T>(_ error: ErrorMessages) -> Observable<T>{
       return Observable.error(error)
    }
    
    private func prepareHeader(isAuthorized: Bool = false, isJson: Bool = false) -> [(String, String)] {
        var httpHeaders: [(String, String)] = []
   
        if isAuthorized, let savedToken = UserDefaults.standard.string(forKey: DefaultNames.authToken) {
            httpHeaders.append(("Authorization", "Bearer \(savedToken)"))
        }
        httpHeaders.append(("Content-Type", "application/json"))
        httpHeaders.append(("Accept", "*/*"))
        return httpHeaders
    }
    
    private func makeURLRequestWithHeader(url: URL, method: HttpMethod, header: [(String, String)]? = nil) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        header?.forEach{ (key, value) in
        urlRequest.addValue(value, forHTTPHeaderField: key)
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

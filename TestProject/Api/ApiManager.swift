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

class ApiManager {
    let disposeBag = DisposeBag()
    
    private let urlSession = URLSession(configuration: .default)
    private let apiPrefix = "https://google.com"
    
    static let shared = ApiManager()
    
    private init() {}
    
    func processData(action:@escaping (Data, HTTPURLResponse) -> Void) {
        response(request: URLRequest(url: URL(string: apiPrefix)!))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                action(result.data, result.response)
            })
            .disposed(by: disposeBag)
    }
    
    func response(request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)> {
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

                observer.on(.next((httpResponse, data)))
                observer.on(.completed)
            }

            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}

//
//  Api.swift
//  TestProject
//
//  Created by Oleg on 11.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import Foundation
import RxSwift

final class Api {
    private let apiManager = ApiManager()
    
    func login(with: LoginData) -> Observable<AuthData> {
        return apiManager.makePostRequest(endpoint: "/auth/login", toPost: with)
    }
    
    func getPensList(isArchived: Bool = false) -> Observable<[Pen]> {
        return apiManager.makeGetRequest(endpoint: "/pen/list", isAuthorized: true, parameters: [("archived", String(isArchived))])
    }
    
    func getPen(byId: Int) -> Observable<Pen> {
        return apiManager.makeGetRequest(endpoint: "/pen/get/\(byId)", isAuthorized: true)
    }
    
    func getFrames() -> Observable<[Frame]> {
       return apiManager.makeGetRequest(endpoint: "/camera/frames/1/1596088516", isAuthorized: true)
    }
    
    func getImageData(url: URL) -> Observable<Data> {
        return apiManager.makeGetRequest(url: url)
    }
}

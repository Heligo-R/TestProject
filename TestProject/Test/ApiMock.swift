//
//  ApiManagerMock.swift
//  TestProject
//
//  Created by Oleg on 24.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import Foundation
import RxSwift

class ApiMock {
    private var result: Data?
    
    init(result: Dictionary<String, Any>) {
        do {
            self.result = try JSONSerialization.data(withJSONObject: result, options: [])
        } catch {
            debugPrint(error.localizedDescription)
            self.result = nil
        }
    }
    
    func makePostRequest<T: Decodable, PostObject: Encodable>(toPost: PostObject) -> Observable<T> {
        let encodedData = try? JSONEncoder().encode(toPost)
        debugPrint(encodedData as Any)
        
        return proceedResponse()
    }
    
    func proceedResponse<T: Decodable> () -> Observable<T> {
        return Observable.create { observer in
            if let data = self.result {
                if let decodedResult: T = try? JSONDecoder().decode(T.self, from: data)  {
                    observer.on(.next(decodedResult))
                } else {
                    observer.on(.error(ErrorMessages.jsonEncodingError))
                }
            }
            return Disposables.create()
        }
    }
}

final class SupportManagerMock: ApiMock {
    init() {
        let supportMockData = ["message": "Your support will be provided!", "timeToWait" : "200 Hours"]
        super.init(result: supportMockData)
    }
}

final class NewsDataManagerMock: ApiMock {
    init() {
        let newsMockData = ["news" : [
            ["id" : 0, "name" : "Something happened", "newsType" : 1, "description" : "CNN Travel's series often carry sponsorship originating from the countries and regions we profile. However, CNN retains full editorial control over all of its reports. Read the policy.\n (CNN) — For more than a century, Bulgaria has had little trouble enticing people to its beach resorts scattered along the Black Sea coast. City-breakers head to its main cities -- including Sofia, the capital, and Plovdiv, the 2019 European Capital of Culture -- for an enjoyable blend of culture and hearty Bulgarian gastronomy.", "countOfSmth" : 22, "additionalLetter" : "Burgas Lakes \nThanks to its airport, Burgas is commonly used as a jumping-off point for the nearby Black Sea resorts of Sozopol and Sunny Beach. But the coastal city has a few sights of its own that will appeal to nature lovers and birdwatchers, namely the half-moon of three lakes curving around it."],
            ["id" : 1, "name" : "Belarus' leader helicopters over Minsk with a rifle as protesters below demand his resignation", "newsType" : 2, "description" : "Belarusian President Alexander Lukashenko responded to huge anti-government protests and calls for his resignation by posting video of himself flying over Minsk in riot gear, with a rifle hanging from his shoulder.", "countOfSmth" : 3344, "additionalLetter" : "President Alexander Lukashenko brandishing a rifle near the Palace of Independence in Minsk, Sunday, as seen in video from state TV."],
            ["id" : 2, "name" : "UK's biggest supermarket adds 16,000 jobs to cope with online shopping boom", "newsType" : 0, "description" : "Tesco is creating 16,000 jobs to meet surging demand in its online business, delivering a rare boost to the struggling UK economy.\nBritain's largest supermarket chain said in a statement on Monday that the new permanent roles are in addition to 4,000 jobs it has already added since the start of the coronavirus crisis. ", "countOfSmth" : -34]]]
        super.init(result: newsMockData)
    }
}

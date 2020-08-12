//
//  LocalRepo.swift
//  TestProject
//
//  Created by Oleg on 18.06.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import Foundation
import RealmSwift

struct DefaultNames {
    static let authToken = "authToken" 
}

final class LocalRepo {    
    func addEntity<T: Object>(_ entity: T) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(entity)
        }
    }
    
    func getSimpleEntity(token: String) -> SimpleEntity? {
        let realm = try! Realm()
        let entitiesFound = realm.objects(SimpleEntity.self).filter("token == '\(token)'")

        return entitiesFound.first
    }
    
    func getUser(_ credentials: (String, String)) -> User? {
        let realm = try! Realm()
        let userColl = realm.objects(User.self).filter("email == '\(credentials.0)'")
        if userColl.isEmpty { return nil }
        if let userFromDB = userColl.first, userFromDB.password == credentials.1 {
            return userFromDB
        } else { return nil }
    }
    
    func userNotExist(_ user: User) -> Bool {
        let realm = try! Realm()
        return realm.objects(User.self).filter("email == '\(user.email)'").isEmpty
    }
}

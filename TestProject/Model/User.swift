//
//  File.swift
//  TestProject
//
//  Created by Oleg on 16.06.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//
import RealmSwift

class User: Object {
    @objc dynamic var email = ""
    @objc dynamic var password = ""
    @objc dynamic var name = ""
    @objc dynamic var surname = ""
    @objc dynamic var birthDate: Date? = nil
    @objc dynamic var imagePath: String? = nil
}

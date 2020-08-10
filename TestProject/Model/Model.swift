//
//  Model.swift
//  TestProject
//
//  Created by Oleg on 10.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import RealmSwift

protocol TokenedEntity {
    dynamic var token: String { get set }
}

class SimpleEntity: Object, TokenedEntity {
    @objc dynamic var value = ""
    @objc dynamic var token = ""
}

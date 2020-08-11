//
//  Login.swift
//  TestProject
//
//  Created by Oleg on 11.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

struct LoginForm: Codable {
    var login: String
    var password: String
}

struct AuthData: Codable {
    var id: Int
    var user_id: Int
    var expires_at: String
    var token: String
}

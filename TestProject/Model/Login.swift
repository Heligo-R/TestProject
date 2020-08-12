//
//  Login.swift
//  TestProject
//
//  Created by Oleg on 11.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

struct LoginData: Codable {
    let login: String
    let password: String
}

struct AuthData: Codable {
    enum CodingKeys: String, CodingKey {
        case id, token
        case userId = "user_id"
        case expiresAt = "expires_at"
    }
    
    let id: Int
    let userId: Int
    let expiresAt: String
    let token: String
}

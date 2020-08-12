//
//  Pens.swift
//  TestProject
//
//  Created by Oleg on 11.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

struct Pen: Codable {
    enum CodingKeys: String, CodingKey {
        case id, createdAt, updatedAt, users
        case penIdName = "pen_id_name"
        case numberHeads = "number_heads"
        case numberFeeds = "number_feeds"
        case targetDMIntake = "target_DM_intake"
        case startDate = "start_date"
        case clientLocationId = "client_location_id"
        case isArchived = "archived"
        case clientLocations = "client_locations"
    }
    
    let id: Int
    let penIdName: String
    let numberHeads: Int
    let numberFeeds: Int
    let targetDMIntake: Int
    let startDate: String
    let isArchived: Bool
    let clientLocationId: Int
    let createdAt: String
    let updatedAt: String
    let users: [PenUser]
    let clientLocations: ClientLocations?
}

struct PenUser: Codable {
    enum CodingKeys: String, CodingKey {
        case id, email, role, createdAt, updatedAt
        case firstName = "first_name"
        case lastName = "last_name"
        case isArchived = "archived"
    }
    
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let role: String
    let isArchived: Bool
    let createdAt: String
    let updatedAt: String
}

struct ClientLocations: Codable {
    enum CodingKeys: String, CodingKey {
        case id, latitude, longitude, createdAt, updatedAt
        case locationName = "location_name"
        case clientId = "client_id"
    }
    
    let id: Int
    let locationName: String
    let latitude: String
    let longitude: String
    let clientId: Int
    let createdAt: String
    let updatedAt: String
}

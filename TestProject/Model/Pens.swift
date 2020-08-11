//
//  Pens.swift
//  TestProject
//
//  Created by Oleg on 11.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

struct Pen: Codable {
    var id: Int
    var pen_id_name: String
    var number_heads: Int
    var number_feeds: Int
    var target_DM_intake: Int
    var start_date: String
    var archived: String
    var client_location_id: Int
    var createdAt: String
    var updatedAt: String
    var users: [PenUser]
}

struct PenUser: Codable {
    var id: Int
    var first_name: String
    var last_name: String
    var email: String
    var role: String
    var archived: String
    var createdAt: String
    var updatedAt: String
}

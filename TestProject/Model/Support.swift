//
//  Support.swift
//  TestProject
//
//  Created by Oleg on 01.09.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import Foundation

struct Support: Codable {
    let email: String
    let subject: String
    let message: String
}

struct SupportResponse: Codable {
    let message: String
    let timeToWait: String
}

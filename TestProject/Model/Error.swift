//
//  Error.swift
//  TestProject
//
//  Created by Oleg on 11.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import Foundation

struct ErrorMessage: Codable, Error {
    let statusCode: Int
    let error: String
    let message: String
}

enum ErrorMessages: Error {
    case urlComposingError
    case jsonEncodingError
}

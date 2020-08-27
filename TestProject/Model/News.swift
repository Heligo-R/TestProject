//
//  News.swift
//  TestProject
//
//  Created by Oleg on 24.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import Foundation

struct News: Codable {
    let description: String
    let newsType: NewsType
    let newsTags: String?
    let name: String
    let id: Int
    let countOfSmth: Int
    let additionalLetter: String?
}

struct Newsletter: Codable {
    let news: [News]
}

enum NewsType: Int, Codable {
    case trading, important, trash
}

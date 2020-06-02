//
//  File.swift
//  TestProject
//
//  Created by Oleg on 27.05.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    func verification(_ expression: String?, required:Bool = false) -> Bool {
        if required && (self == nil || self == "") { return false }
        guard let text = self else { return true }
        guard text.count > 0 else { return true }
        guard let expression = expression else { return true }
        do {
            let regex = try NSRegularExpression(pattern: expression, options: .caseInsensitive)
            return regex.firstMatch(in: text, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, text.count)) != nil
        } catch {
            return false
        }
    }
}

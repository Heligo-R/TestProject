//
//  ValidationManager.swift
//  TestProject
//
//  Created by Oleg on 27.05.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//
import Foundation

enum VerificationRegex: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    case password = "(?=.*[0-9])(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*]{8,}"
    case name = "^[A-Z][a-z'\\-]{2,20}$"
    case text = "*"
}

enum ValidationStatus{
    case empty
    case filled
    case mistake
}

class ValidationManager
{
    func verifyText(_ inputString: String?, expression: VerificationRegex?) -> ValidationStatus {
        if let inputString = inputString, inputString.count == 0 {
            return(.empty)
        } else {
            if !inputString.verification(expression?.rawValue) {
                return(.mistake)
            } else {
                return(.filled)
            }
        }
    }
    
    func verifyAge(_ inputDate: Date?, passAge: Int) -> ValidationStatus {
        guard let inputDate = inputDate else { return(.empty) }

        let components = Calendar.current.dateComponents([.year], from: inputDate, to: Date())

        if  components.year ?? 0 >= passAge {
            return(.filled)
            } else {
            return(.mistake)
        }
    }
}

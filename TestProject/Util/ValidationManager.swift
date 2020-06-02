//
//  ValidationManager.swift
//  TestProject
//
//  Created by Oleg on 27.05.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//
enum VerificationRegex: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    case password = "(?=.*[0-9])(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*]{8,}"
}

class ValidationManager
{
    public func verifyTextField(_ textField: ValidatableTextField, expression: VerificationRegex?) {
        if let text = textField.text, text.count == 0 {
            textField.updateStatus(.empty)
        } else {
            if !textField.text.verification(expression?.rawValue) {
                textField.updateStatus(.mistake)
            } else {
                textField.updateStatus(.filled)
            }
        }
    }
}



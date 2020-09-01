//
//  FlowSupportView.swift
//  TestProject
//
//  Created by Oleg on 31.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

final class FlowSupportView: XibWrapperView {
    @IBOutlet private weak var emailTextField: ValidatableTextField!
    @IBOutlet private weak var subjectTextField: UITextField!
    @IBOutlet private weak var messageTextField: ValidatableTextField!
    
    let validation = ValidationManager()
    
    @IBAction func actionButton(_ sender: Any) {
        var readingFailed = false
        
        func validateField (field: ValidatableTextField, expression: VerificationRegex){
            let validationResult = validation.verifyText(field.text, expression: expression)
            if validationResult != .filled { readingFailed = true }
            field.updateStatus(validationResult)
        }
        
        validateField(field: emailTextField, expression: .email)
        validateField(field: messageTextField, expression: .text)
        if readingFailed {
            return
        } else { return }
    }
}

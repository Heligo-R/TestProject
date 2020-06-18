//
//  LoginViewController.swift
//  TestProject
//
//  Created by Oleg on 01.06.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: ValidatableTextField!
    @IBOutlet weak var passwordTextField: ValidatableTextField!
    @IBOutlet weak var loginStackFields: UIStackView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    let validation = ValidationManager()
    let localRepo = LocalRepo()
    
    typealias Credentials = (String, String)
    
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        if sender == emailTextField {
            emailTextField.updateStatus(validation.verifyText(emailTextField.text, expression: .email))
        }
        if sender == passwordTextField {
            passwordTextField.updateStatus(validation.verifyText(passwordTextField.text, expression: .password))
        }
        
        errorLabel.isHidden = true
    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        if sender == submitButton {
            guard let credentials = readFields() else { return }
            if localRepo.getUser(credentials) == nil { errorLabel.isHidden = false }
            }
        }
    
    func readFields() -> Credentials? {
        var readingFailed = false
        
        func validateField (field: ValidatableTextField, expression: VerificationRegex){
            let validationResult = validation.verifyText(field.text, expression: expression)
            if validationResult != .filled { readingFailed = true }
            field.updateStatus(validationResult)
        }
        
        validateField(field: emailTextField, expression: .email)
        validateField(field: passwordTextField, expression: .password)
        
        if readingFailed {
            return nil
        } else { return (emailTextField.text!, passwordTextField.text!) }
    }
}

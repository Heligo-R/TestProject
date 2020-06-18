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
    
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        let validation = ValidationManager()
        
        if sender == emailTextField {
            emailTextField.updateStatus(validation.verifyText(emailTextField.text, expression: .email))
        }
        if sender == passwordTextField {
            passwordTextField.updateStatus(validation.verifyText(passwordTextField.text, expression: .password))
        }
    }
}

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
    
    let validation = ValidationManager()
    
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        if sender == emailTextField {
            emailTextField.updateStatus(validation.verify(emailTextField.text, expression: .email))
        }
        if sender == passwordTextField {
            passwordTextField.updateStatus(validation.verify(passwordTextField.text, expression: .password))
        }
    }
    
    @IBAction func handleSignUpButtonTap(_ sender: Any) {
        let registrationVC = RegistrationViewController()
        navigationController?.pushViewController(registrationVC, animated: true)
    }
}

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
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        if sender == emailTextField {
            validation.verifyTextField(emailTextField, expression: .email)
        }
        if sender == passwordTextField {
            validation.verifyTextField(passwordTextField, expression: .password)
        }
    }
    
}

//
//  RegistrationViewController.swift
//  TestProject
//
//  Created by Oleg on 04.06.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit
import MobileCoreServices

class RegistrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var nameTextField: ValidatableTextField!
    @IBOutlet weak var surnameTextField: ValidatableTextField!
    @IBOutlet weak var emailTextField: ValidatableTextField!
    @IBOutlet weak var passwordTextField: ValidatableTextField!
    @IBOutlet weak var birthDatePicker: ValidatableDatePicker!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    let validation = ValidationManager()
    let localRepo = LocalRepo()
    
    private var imageLocal: String?
    
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        switch sender {
        case nameTextField:
            nameTextField.updateStatus(validation.verifyText(sender.text, expression: .name))
        case surnameTextField:
            surnameTextField.updateStatus(validation.verifyText(sender.text, expression: .name))
        case emailTextField:
            emailTextField.updateStatus(validation.verifyText(sender.text, expression: .email))
        case passwordTextField:
            passwordTextField.updateStatus(validation.verifyText(sender.text, expression: .password))
        default: break
        }
    }
    
    @IBAction func datePicked(_ sender: UIDatePicker) {
        if sender == birthDatePicker {
            birthDatePicker.updateStatus(validation.verifyAge(birthDatePicker.date, passAge: 16))
        }
    }
    
    @IBAction func buttonTouchUp(_ sender: UIButton) {
        switch sender {
        case profileImageButton:
            imageSelectorSetup()
        case registerButton:
            guard let user = readFields() else { return }
            if localRepo.userNotExist(user) {
                localRepo.addEntity(user)
                Alert(title: "Succeed!", message: "Registration completed!", buttonText: "Ok")
            } else{
                Alert(title: "Something wrong.", message: "User with same email already exists", buttonText: "Ok")
            }
        default:
            break
        }
    }
    
    func Alert(title: String, message: String, buttonText: String, handler: ((UIAlertAction) -> Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: buttonText, style: .default, handler: handler)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func readFields() -> User?{
        var readingFailed = false
        
        func validateField (field: ValidatableTextField, expression: VerificationRegex){
            let validationResult = validation.verifyText(field.text, expression: expression)
            if validationResult != .filled { readingFailed = true }
            field.updateStatus(validationResult)
        }
        
        validateField(field: nameTextField, expression: .name)
        validateField(field: surnameTextField, expression: .name)
        validateField(field: emailTextField, expression: .email)
        validateField(field: passwordTextField, expression: .password)
        
        let validationResult = validation.verifyAge(birthDatePicker.date, passAge: 16)
        if validationResult != .filled { readingFailed = true }
        birthDatePicker.updateStatus(validationResult)
        
        if readingFailed {
            return nil
        } else {
            let user = User()
            user.name = nameTextField.text!
            user.surname = surnameTextField.text!
            user.email = emailTextField.text!
            user.password = passwordTextField.text!
            user.birthDate = birthDatePicker.date
            user.imagePath = imageLocal
            return user
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[.mediaType] as! String
        if mediaType.isEqual(kUTTypeImage as String){
            let image = info[.originalImage] as! UIImage
            profileImageButton.setImage(image, for: .normal)
            if let url = info[.imageURL] as? URL{
                let imgName = url.lastPathComponent
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                imageLocal = documentDirectory?.appending(imgName)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imageSelectorSetup(){
        let alertController = UIAlertController(title:"Select Image From", message: nil, preferredStyle: .alert)
        
        func alertActionHandler(type: UIImagePickerController.SourceType){
            if UIImagePickerController.isSourceTypeAvailable(type){
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = type
                imagePicker.delegate = self
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            alertActionHandler(type: .camera)
        }
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            alertActionHandler(type: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

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
    @IBOutlet weak var birthDatePicker: ValidatableDatePicker!
    @IBOutlet weak var profileimage: UIImageView!
    
    let tapRec = UITapGestureRecognizer()
    let validation = ValidationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapRec.addTarget(self, action: #selector(viewTapped(tapGestureRecognizer:)))
        profileimage.addGestureRecognizer(tapRec)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[.mediaType] as! String
        if mediaType.isEqual(kUTTypeImage as String){
            let image = info[.originalImage] as! UIImage
            profileimage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        if sender == nameTextField {
            nameTextField.updateStatus(
                validation.verifyText(sender.text, expression: .name))
        }
        if sender == surnameTextField {
            surnameTextField.updateStatus(
                validation.verifyText(sender.text, expression: .name))
        }
        
    }
    
    @IBAction func datePicked(_ sender: UIDatePicker) {
        if sender == birthDatePicker {
            birthDatePicker.updateStatus(validation.verifyAge(birthDatePicker.date, passAge: 16))
        }
    }
    
    @objc func viewTapped(tapGestureRecognizer: UITapGestureRecognizer){
        if tapGestureRecognizer.view == profileimage{ imageSelectorSetup() }
    }
    
    func imageSelectorSetup(){
        let alertController = UIAlertController(title:"Select Image From", message: "", preferredStyle: .actionSheet)
        
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
        self.present(alertController, animated: true)
    }
}

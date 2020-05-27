//
//  ValidationManager.swift
//  TestProject
//
//  Created by Oleg on 27.05.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

@objc protocol IValidationManager : class {
    func verificated()
}

@objc protocol IValidatable : class {
    var isValid: Bool { get }
}

class ValidationManager : UIControl, IValidationManager
{
    @IBOutlet var verifiedControls: [UIControl]?
    @IBOutlet var managedControls: [UIControl]?
    
    private (set) var valid : Bool = false {
        didSet {
            self.sendActions(for: .valueChanged)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.verificated()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.verificated()
    }
    
    func verificated() {
        self.checkVerifiedControls()
        self.controlsAction()
    }
    
    private func checkVerifiedControls() {
        guard let list:[IValidatable] = self.verifiedControls?.filter(
            {$0 is IValidatable}) as? [IValidatable]
            else { return }
        self.valid = list.filter({!$0.isValid}).count==0
    }
    
    private func controlsAction() {
        guard let list = self.managedControls else { return }
        for item in list {
            item.isEnabled = self.valid
        }
    }
}



//
//  TextEditValidated.swift
//  TestProject
//
//  Created by Oleg on 27.05.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

class ValidatableTextField: UITextField
{
    @IBInspectable var valueRequired: Bool = true
    @IBInspectable var borderMistakeColor: UIColor = .red
    @IBInspectable var borderEmptyColor: UIColor   = .lightGray
    @IBInspectable var borderFilledColor: UIColor  = .green
    @IBInspectable var mistake: String = ""
    @IBInspectable var showMistake: Bool = true
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = self.layer.borderColor {
                return  UIColor(cgColor: color)
            }
            return .black
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.adjustLabel()
    }
    
    override func layoutSubviews() {
        self.appendLabel()
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.adjustLabel()
    }
    
    private func adjustLabel(){
        self.label.numberOfLines = 0
        self.label.font = UIFont.systemFont(ofSize: 12)
        self.label.textColor = self.borderMistakeColor
        self.label.isHidden = true
    }
    
    private func appendLabel() {
        if self.label.superview != nil { return }
        guard let superview = self.superview as? UIStackView else { return }
        
        if let index = superview.arrangedSubviews.firstIndex(of: self) {
            superview.insertArrangedSubview(self.label, at: index + 1)
        }
        
        self.label.text = self.mistake
    }
    
    func updateStatus(_ status: ValidationStatus){
        switch status {
        case .empty:
            if valueRequired {
                self.borderColor = self.borderMistakeColor
            }else { self.borderColor = self.borderEmptyColor }
        case .filled:
            self.borderColor = self.borderFilledColor
        case .mistake:
            self.borderColor = self.borderMistakeColor
        }
        self.label.isHidden = status != .mistake
    }
}

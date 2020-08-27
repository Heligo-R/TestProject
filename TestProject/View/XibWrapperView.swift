//
//  NibWrapperView.swift
//  TestProject
//
//  Created by Oleg on 19.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

class XibWrapperView: UIView {
    @IBOutlet internal var contentView: UIView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromXib()
        prepareContentView()
        initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromXib()
        prepareContentView()
        initialSetup()
    }
    
    private func loadFromXib(){
        Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self)
        addSubview(contentView)
    }
    
    private func prepareContentView() {
        addSubview(contentView)
        contentView.connectConstraintsToContainer(self)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        contentView.prepareForInterfaceBuilder()
    }
    
    internal func initialSetup() {}
}

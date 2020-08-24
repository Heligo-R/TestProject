//
//  UIHelper.swift
//  TestProject
//
//  Created by Oleg on 20.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

extension UIView {
    func connectConstraintsToContainer(_ containerView: UIView, anchors: [Anchor] = [.leading, .top, .trailing, .bottom]) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        for anchor in anchors {
            switch anchor {
            case .leading:  self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            case .top: self.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            case .trailing: self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
            case .bottom: self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            }
        }
    }
    
    enum Anchor {
        case leading, top, trailing, bottom
    }
}

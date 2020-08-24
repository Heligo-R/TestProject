//
//  UIHelper.swift
//  TestProject
//
//  Created by Oleg on 19.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

protocol XibView: class {
    func loadFromXib()
}

extension XibView where Self: UIView {
    /*internal func loadFromXib<T: UIView>(T) -> T {
    
    }*/
}

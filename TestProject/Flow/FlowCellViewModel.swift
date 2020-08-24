//
//  FlowCellViewModel.swift
//  TestProject
//
//  Created by Oleg on 20.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

final class FlowCellViewModel {
    let indexPath: IndexPath
    
    var selectedState: FlowCellState?
    
    init(for indexPath: IndexPath) {
        self.indexPath = indexPath
    }
}

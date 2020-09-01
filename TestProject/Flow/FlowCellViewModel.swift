//
//  FlowCellViewModel.swift
//  TestProject
//
//  Created by Oleg on 20.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit
import RxSwift

final class FlowCellViewModel {
    let cellRow: Int
    
    var selectedState: FlowCellState?
    
    init(for cellRow: Int) {
        self.cellRow = cellRow
    }
}

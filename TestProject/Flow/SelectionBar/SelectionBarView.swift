//
//  SelectionBarView.swift
//  TestProject
//
//  Created by Oleg on 19.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit
import RxSwift

enum FlowCellState {
    case details, tag, reference, question
}

protocol SelectionDelegate {
    func proceedBarSelection(selectedState: FlowCellState)
}

final class SelectionBarView: XibWrapperView {
    @IBOutlet private weak var detailsButton: UIButton!
    @IBOutlet private weak var tagButton: UIButton!
    @IBOutlet private weak var referenceButton: UIButton!
    @IBOutlet private weak var questionButton: UIButton!
    
    private var selectedState: FlowCellState = FlowCellDefaults.defaultFlowCellState
    
    var selectionColor: UIColor = UIColor.systemTeal
    var defaultColor: UIColor = UIColor.tertiarySystemGroupedBackground
    
    var delegate: SelectionDelegate?
    
    @IBAction private func actionTouchButton(_ sender: UIButton) {
        switch selectedState {
        case .details: detailsButton.backgroundColor = defaultColor
        case .tag: tagButton.backgroundColor = defaultColor
        case .question: questionButton.backgroundColor = defaultColor
        case .reference: referenceButton.backgroundColor = defaultColor
        }
        
        switch sender {
        case detailsButton:
            detailsButton.backgroundColor = selectionColor
            selectedState = .details
        case tagButton:
            tagButton.backgroundColor = selectionColor
            selectedState = .tag
        case referenceButton:
            referenceButton.backgroundColor = selectionColor
            selectedState = .reference
        case questionButton:
            questionButton.backgroundColor = selectionColor
            selectedState = .question
        default: break
        }
        delegate?.proceedBarSelection(selectedState: selectedState)
    }
    
    override internal func initialSetup() {
        detailsButton.backgroundColor = defaultColor
        tagButton.backgroundColor = defaultColor
        referenceButton.backgroundColor = defaultColor
        questionButton.backgroundColor = defaultColor
        
        switch FlowCellDefaults.defaultFlowCellState {
        case .details: detailsButton.backgroundColor = selectionColor
        case .tag: tagButton.backgroundColor = selectionColor
        case .question: questionButton.backgroundColor = selectionColor
        case .reference: referenceButton.backgroundColor = selectionColor
        }
    }
}

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

protocol SelectionDelegate: class {
    func proceedBarSelection(selectedState: FlowCellState)
}

final class SelectionBarView: XibWrapperView {
    @IBOutlet private weak var detailsButton: UIButton!
    @IBOutlet private weak var tagButton: UIButton!
    @IBOutlet private weak var referenceButton: UIButton!
    @IBOutlet private weak var questionButton: UIButton!
    
    private var currentState: FlowCellState = FlowCellDefaults.defaultFlowCellState
    
    var selectionColor: UIColor = UIColor.systemTeal
    var defaultColor: UIColor = UIColor.tertiarySystemGroupedBackground
    
    weak var delegate: SelectionDelegate?
    
    @IBAction private func actionTouchButton(_ sender: UIButton) {
        let selectedState: FlowCellState
        
        switch sender {
        case detailsButton: selectedState = .details
        case tagButton: selectedState = .tag
        case referenceButton: selectedState = .reference
        case questionButton: selectedState = .question
        default: selectedState = FlowCellDefaults.defaultFlowCellState
        }
        
        switchState(selectedState: selectedState)
        delegate?.proceedBarSelection(selectedState: selectedState)
    }
    
    private func switchState(selectedState: FlowCellState) {
        if selectedState == currentState { return }
        
        switch currentState {
        case .details: detailsButton.backgroundColor = defaultColor
        case .tag: tagButton.backgroundColor = defaultColor
        case .question: questionButton.backgroundColor = defaultColor
        case .reference: referenceButton.backgroundColor = defaultColor
        }
        
        switch selectedState {
        case .details: detailsButton.backgroundColor = selectionColor
        case .tag: tagButton.backgroundColor = selectionColor
        case .question: questionButton.backgroundColor = selectionColor
        case .reference: referenceButton.backgroundColor = selectionColor
        }
        currentState = selectedState
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
    
    func resetState() {
        switchState(selectedState: FlowCellDefaults.defaultFlowCellState)
    }
}

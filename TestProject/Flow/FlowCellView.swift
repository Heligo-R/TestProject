//
//  FlowCellView.swift
//  TestProject
//
//  Created by Oleg on 17.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

struct Defaults {
   static let defaultFlowCellState: FlowCellState = .details
}

protocol FlowCellDelegate {
    func manageExpandedCells(with indexPath: IndexPath)
    func updateTable()
}

final class FlowTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var desctiptionLabel: UILabel!
    
    @IBOutlet weak var selectionBarView: UIView!
    @IBOutlet weak var selectableContainerView: UIView!
    
    let selectionBar = SelectionBarView()
    let detailsView = DetailsView()
    
    var model: FlowCellViewModel?
    var delegate: FlowCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionBar.delegate = self
    }
    
    @IBAction func actionTouchButton(_ sender: UIButton) {
        switch sender {
        case moreButton:
            switchCellMode(isSelectionMode: true)
            
            selectionBarView.addSubview(selectionBar)
            selectionBar.connectConstraintsToContainer(selectionBarView, anchors: [.top, .leading, .trailing])
            selectionBar.bottomAnchor.constraint(lessThanOrEqualTo: selectionBarView.bottomAnchor).isActive = true
            
            if let indexPath = model?.indexPath {
                delegate?.manageExpandedCells(with: indexPath)
            }
    
            proceedBarSelection(selectedState: Defaults.defaultFlowCellState)
        default: break
        }
    }
    
    func hideDetails() {
        selectionBar.removeFromSuperview()
        deselectState()

        switchCellMode(isSelectionMode: false)
    }
    
    func deselectState() {
        switch model?.selectedState {
        case .details: detailsView.removeFromSuperview()
        case .tag: break
        case .question: break
        case .reference: break
        case .none: break
        }
        model?.selectedState = .none
    }
    
    func switchCellMode(isSelectionMode: Bool) {
        moreButton.isHidden = isSelectionMode
        desctiptionLabel.isHidden = isSelectionMode
        selectionBarView.isHidden = !isSelectionMode
        selectableContainerView.isHidden = !isSelectionMode
    }
}

extension FlowTableViewCell: SelectionDelegate {
    func proceedBarSelection(selectedState: FlowCellState) {
        if model?.selectedState == selectedState { return }
        
        deselectState()
        model?.selectedState = selectedState
        
        switch selectedState {
        case .details:
            selectableContainerView.addSubview(detailsView)
            detailsView.connectConstraintsToContainer(selectableContainerView, anchors: [.top, .leading, .trailing])
            detailsView.bottomAnchor.constraint(lessThanOrEqualTo: selectableContainerView.bottomAnchor).isActive = true
        case .tag: break
        case .question: break
        case .reference: break
        }
        delegate?.updateTable()
    }
}

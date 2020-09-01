//
//  FlowCellView.swift
//  TestProject
//
//  Created by Oleg on 17.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

struct FlowCellDefaults {
   static let defaultFlowCellState: FlowCellState = .details
}

fileprivate struct Defaults {
    static let exclamationmark = "exclamationmark"
    static let cart = "cart"
    static let trash = "trash"
}

protocol FlowCellDelegate: class {
    func manageExpandedCells(with row: Int?)
    func updateTable()
}

final class FlowTableViewCell: UITableViewCell {
    @IBOutlet private weak var iconImage: UIImageView!
    @IBOutlet private weak var iconLabel: UILabel!
    @IBOutlet private weak var itemImage: UIImageView!
    @IBOutlet private weak var itemNameLabel: UILabel!

    @IBOutlet private weak var containerView: UIView!
    
    @IBOutlet private weak var moreButton: UIButton!
    @IBOutlet private weak var desctiptionLabel: UILabel!
    
    @IBOutlet private weak var selectionBarView: UIView!
    @IBOutlet private weak var selectableContainerView: UIView!
    
    private let selectionBar = SelectionBarView()
    private let detailsView = DetailsView()
    private let supportView = FlowSupportView()
    
    private var model: FlowCellViewModel?
    private weak var delegate: FlowCellDelegate?
    
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
            
            if let cellRow = model?.cellRow {
                delegate?.manageExpandedCells(with: cellRow)
            }
    
            proceedBarSelection(selectedState: FlowCellDefaults.defaultFlowCellState)
        default: break
        }
    }
    
    func setupCell(data: News, delegate: SupportViewDelegate & FlowCellDelegate, row: Int) {
        if model == nil {
            model = FlowCellViewModel(for: row)
        }
        if self.delegate == nil {
            self.delegate = delegate
        }
        
        supportView.delegate = delegate
        
        itemNameLabel.text = data.name
        desctiptionLabel.text = data.description
        iconLabel.text = data.newsTags
        switch data.newsType {
        case .important: iconImage.image = UIImage(systemName: Defaults.exclamationmark)
        case .trading: iconImage.image = UIImage(systemName: Defaults.cart)
        case .trash: iconImage.image = UIImage(systemName: Defaults.trash)
        }
        
        detailsView.descriptionLabel.text = data.description
        detailsView.countLabel.text = String(data.countOfSmth)
        detailsView.additionalText.text = data.additionalLetter
        
        hideDetails()
    }
    
    func hideDetails() {
        selectionBar.removeFromSuperview()
        selectionBar.resetState()
        
        deselectState()
        switchCellMode(isSelectionMode: false)
        delegate?.updateTable()
    }
    
    private func deselectState() {
        switch model?.selectedState {
        case .details: detailsView.removeFromSuperview()
        case .tag: break
        case .question: supportView.removeFromSuperview()
        case .reference: break
        case .none: break
        }
        model?.selectedState = .none
    }
    
    private func switchCellMode(isSelectionMode: Bool) {
        moreButton.isHidden = isSelectionMode
        desctiptionLabel.isHidden = isSelectionMode
        selectionBarView.isHidden = !isSelectionMode
        selectableContainerView.isHidden = !isSelectionMode
    }
}

extension FlowTableViewCell: SelectionDelegate {
    func proceedBarSelection(selectedState: FlowCellState) {
        if model?.selectedState == selectedState {
            delegate?.manageExpandedCells(with: nil)
            return
        }
        
        deselectState()
        model?.selectedState = selectedState
        
        switch selectedState {
        case .details:
            selectableContainerView.addSubview(detailsView)
            detailsView.connectConstraintsToContainer(selectableContainerView, anchors: [.top, .leading, .trailing])
            detailsView.bottomAnchor.constraint(lessThanOrEqualTo: selectableContainerView.bottomAnchor).isActive = true
        case .tag: break
        case .question:
            selectableContainerView.addSubview(supportView)
            supportView.connectConstraintsToContainer(selectableContainerView, anchors: [.top, .leading, .trailing])
            supportView.bottomAnchor.constraint(lessThanOrEqualTo: selectableContainerView.bottomAnchor).isActive = true
        case .reference: break
        }
        delegate?.updateTable()
    }
}

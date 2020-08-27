//
//  FLowStoryboard.swift
//  TestProject
//
//  Created by Oleg on 17.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate struct Defaults {
    static let exclamationmark = "exclamationmark"
    static let cart = "cart"
    static let trash = "trash"
}

final class FlowViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel = FlowViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        tableView.rowHeight = UITableView.automaticDimension
        
        viewModel.retrieveData().bind(to: tableView.rx.items(cellIdentifier: String(describing: FlowTableViewCell.self))) { row, element, cell in
            guard let cell = cell as? FlowTableViewCell else { return }
        
            cell.model = FlowCellViewModel(for: row)
            cell.delegate = self
            cell.itemNameLabel.text = element.name
            cell.desctiptionLabel.text = element.description
            cell.iconLabel.text = element.newsTags
            switch element.newsType {
            case .important: cell.iconImage.image = UIImage(systemName: Defaults.exclamationmark)
            case .trading: cell.iconImage.image = UIImage(systemName: Defaults.cart)
            case .trash: cell.iconImage.image = UIImage(systemName: Defaults.trash)
            }
            
            cell.detailsView.descriptionLabel.text = element.description
            cell.detailsView.countLabel.text = String(element.countOfSmth)
            cell.detailsView.additionalText.text = element.additionalLetter
        }.disposed(by: disposeBag)
    }
}

extension FlowViewController: FlowCellDelegate {
    func manageExpandedCells(with row: Int) {
        if let prevRow = viewModel.expandedCellRow {
            let zeroSection = 0
            (tableView.cellForRow(at: IndexPath(row: prevRow, section: zeroSection)) as? FlowTableViewCell)?.hideDetails()
        }
        viewModel.expandedCellRow = row
    }
    
    func updateTable() {
        tableView.performBatchUpdates(nil, completion: nil)
    }
}


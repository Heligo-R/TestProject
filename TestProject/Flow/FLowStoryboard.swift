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

final class FlowViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel = FlowViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        tableView.rowHeight = UITableView.automaticDimension
        
        viewModel.retrieveData().bind(to: tableView.rx.items(cellIdentifier: String(describing: FlowTableViewCell.self))) { row, element, cell in
            guard let cell = cell as? FlowTableViewCell else { return }
            cell.setupCell(data: element, delegate: self, row: row)
        }.disposed(by: disposeBag)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        adjustInsetForKeyboardShow(isShowing: true, notification: notification)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        adjustInsetForKeyboardShow(isShowing: false, notification: notification)
    }
    
    private func adjustInsetForKeyboardShow(isShowing: Bool, notification: Notification) {
        let params = notification.userInfo
        let rect: CGRect? = (params?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let showMultiplier: CGFloat = isShowing ? 1 : 0
        let adjustmentSize = (rect?.size.height ?? 0) * showMultiplier
        
        tableView.contentInset.bottom = adjustmentSize
        tableView.verticalScrollIndicatorInsets.bottom = adjustmentSize
    }
}

extension FlowViewController: FlowCellDelegate, SupportViewDelegate {
    func manageExpandedCells(with row: Int?) {
        if let prevRow = viewModel.expandedCellRow {
            let zeroSection = 0
            let prevCellIndexPath = IndexPath(row: prevRow, section: zeroSection)
            if let cell = tableView.cellForRow(at: prevCellIndexPath) as? FlowTableViewCell {
                cell.hideDetails()
            } else {
                tableView.reloadRows(at: [prevCellIndexPath], with: .automatic)
            }
        }
        viewModel.expandedCellRow = row
    }
    
    func updateTable() {
        tableView.performBatchUpdates(nil, completion: nil)
    }
    
    func provideSupport(supportRequest: Support) {
        viewModel.requestSupport(request: supportRequest).subscribe{ event in
            switch event {
            case .next(let response):
                let alert = UIAlertController(title: "Support", message: response.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            default: break
            }
        }.disposed(by: disposeBag)
    }
}


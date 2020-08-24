//
//  FLowStoryboard.swift
//  TestProject
//
//  Created by Oleg on 17.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit
import RxSwift

final class FlowViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel = FlowViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        
        /*viewModel.retrieveData().bind(to: tableView.rx.items(cellIdentifier: "FlowCell")) { [unowned self] (row, element, cell) in
            
        }.disposed(by: disposeBag)*/
    }
}

extension FlowViewController: UITableViewDelegate, UITableViewDataSource, FlowCellDelegate {
    func manageExpandedCells(with indexPath: IndexPath) {
        if let prevIndex = viewModel.expandedCellIndex {
            (tableView.cellForRow(at: prevIndex) as! FlowTableViewCell).hideDetails()
        }

        viewModel.expandedCellIndex = indexPath
    }
    
    func updateTable() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlowCell", for: indexPath) as! FlowTableViewCell
        
        cell.model = FlowCellViewModel(for: indexPath)
        cell.delegate = self
        return cell
    }
}


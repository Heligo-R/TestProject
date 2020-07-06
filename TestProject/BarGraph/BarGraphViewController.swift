//
//  BarGraphViewController.swift
//  TestProject
//
//  Created by Oleg on 06.07.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import Foundation

class BarGraphViewController: ViewController{
    @IBOutlet weak var chartView: ChartView!
    
    override func viewDidLoad() {
        chartView.setGraph(generateData(7, max: 1000))
    }
    
    private func generateData(_ numberOfItems: Int, max: Double) -> [ChartViewItem] {
        
        var data = [ChartViewItem]()
        for i in 0 ..< numberOfItems {
            
            let randomNumber = Double(arc4random()).truncatingRemainder(dividingBy: max)
            
            data.append(ChartViewItem(value: randomNumber, timeStamp: Double(i)))
        }
        return data
    }
}

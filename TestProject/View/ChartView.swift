//
//  ChartView.swift
//  TestProject
//
//  Created by Oleg on 02.07.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

struct ChartViewItem {
    var value: Double
    var timeStamp: TimeInterval
}

class ChartView: UIView {
    struct Constants {
        static let cornerRadiusSize = CGSize(width: 5.0, height: 5.0)
        static let insets: UIEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        static let top: CGFloat = 0.0
        static let bottom: CGFloat = 0.0
        static let trailing: CGFloat = 3.0
        static let leading: CGFloat = 3.0
        static let timeGridLenght: TimeInterval = 60 * 60 * 24 * 7
    }
    
    @IBInspectable var columnColor: UIColor = .lightGray
    @IBInspectable var gridColor: UIColor = .darkText
    @IBInspectable var textColor: UIColor = .darkText
    
    private var _items: [ChartViewItem] = []
    private var _maxValue: Float = 0
    private var _maxStamp: TimeInterval = 0
    
    private var barPath = UIBezierPath()
    private var barWidth: CGFloat = 4
    
    func setGraph(_ data: [ChartViewItem]) {
        
    }
    
    override func draw(_ rect: CGRect) {
        //GRAPH
        let maxVal = _maxValue
        let maxStamp = _maxStamp
        
        let graphWidth = rect.width - Constants.leading - Constants.trailing - Constants.insets.left - Constants.insets.right
        let graphHeight = rect.height - Constants.top - Constants.bottom - Constants.insets.top - Constants.insets.bottom
        let graphMinX = Constants.leading + Constants.insets.left
        let graphMinY = Constants.bottom + Constants.insets.bottom
        
        let itemPoint = { (item: ChartViewItem) -> CGPoint in
            let yPoint = graphHeight - ceil((CGFloat(item.value) * graphHeight) / CGFloat(maxVal))
            let xPoint = graphWidth - ceil((CGFloat(maxStamp - item.timeStamp) * graphWidth) / CGFloat(Constants.timeGridLenght))
            return CGPoint(x: xPoint + graphMinX, y: yPoint + graphMinY)
        }
        
        let barWidthOffset: CGFloat = self.barWidth / 2
        
        for item in _items {
            let point = itemPoint(item)
            let origin = CGPoint(x: point.x - barWidthOffset, y: point.y)
            let size = CGSize(width: barWidth, height: point.y)
            let rect = CGRect(origin: origin, size: size)
            let pointPath: UIBezierPath = UIBezierPath(rect: rect)
            
            barPath.append(pointPath)
        }
         columnColor.setStroke()
         barPath.stroke()
    }
}

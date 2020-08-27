//
//  DetailsView.swift
//  TestProject
//
//  Created by Oleg on 21.08.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

final class DetailsView: UIView {
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var onlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Count: "
        return label
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var additionalText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        addSubview(descriptionLabel)
        descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(onlineLabel)
        onlineLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        onlineLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor).isActive = true
        onlineLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(countTitleLabel)
        countTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        countTitleLabel.topAnchor.constraint(equalTo: onlineLabel.bottomAnchor).isActive = true
        
        addSubview(countLabel)
        countLabel.leadingAnchor.constraint(equalTo: countTitleLabel.trailingAnchor).isActive = true
        countLabel.topAnchor.constraint(equalTo: countTitleLabel.topAnchor).isActive = true
        
        addSubview(additionalText)
        additionalText.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        additionalText.topAnchor.constraint(equalTo: countTitleLabel.bottomAnchor).isActive = true
        additionalText.topAnchor.constraint(equalTo: countLabel.bottomAnchor).isActive = true
        additionalText.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        additionalText.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

//
//  NotificationToastView.swift
//  FrenchToast_Example
//
//  Created by Alex Givens on 3/3/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import FrenchToast

class NotificationToastView: ToastView {
            
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        imageView.contentMode = .center
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    func customInit() {
        
        self.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        self.layer.cornerRadius = 6
        self.backgroundColor = .darkGray
        
        // Image View
        addSubview(imageView)
        topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        // Action Button
        addSubview(actionButton)
        trailingAnchor.constraint(equalTo: actionButton.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: actionButton.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: actionButton.bottomAnchor).isActive = true
        actionButton.widthAnchor.constraint(equalToConstant: 72).isActive = true
        
        // Divider view
        let dividerView = UIView()
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = .white
        addSubview(dividerView)
        actionButton.leadingAnchor.constraint(equalTo: dividerView.trailingAnchor).isActive = true
        centerYAnchor.constraint(equalTo: dividerView.centerYAnchor).isActive = true
        dividerView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        // Title label
        addSubview(titleLabel)
        imageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -10).isActive = true
        actionButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10).isActive = true
        centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        
    }
    
}

//
//  BulkActionToastView.swift
//  FrenchToast_Example
//
//  Created by Alex Givens on 3/1/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

import FrenchToast

class BulkActionToastView: UIView, ToastView {
        
    public var layoutDidChangePassthrough: ((UITraitCollection?) -> Void)?
    
    let innerPadding: CGFloat = 12
    
    let checkbox: CheckBox = {
        let checkbox = CheckBox()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let menuButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white.withAlphaComponent(0.1)
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        return button
    }()
    
    let applyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Apply", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = UIColor(red: 74/255, green: 162/255, blue: 194/255, alpha: 1)
        button.layer.borderColor = UIColor(red: 50/255, green: 118/255, blue: 144/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        return button
    }()
    
    var menu: UIMenu {
        return UIMenu(title: "Select an action", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { (_) in
                self.setMenuButtonTitle("Delete")
            }),
            UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc"), handler: { (_) in
                self.setMenuButtonTitle("Copy")
            }),
            UIAction(title: "Move", image: UIImage(systemName: "folder"), handler: { (_) in
                self.setMenuButtonTitle("Move")
            }),
            UIAction(title: "Tag", image: UIImage(systemName: "tag"), handler: { (_) in
                self.setMenuButtonTitle("Tag")
            }),
            UIAction(title: "Stack", image: UIImage(systemName: "square.2.layers.3d"), handler: { (_) in
                self.setMenuButtonTitle("Stack")
            })
        ]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    func customInit() {
        
        self.layer.cornerRadius = 6
        self.backgroundColor = .darkGray
        
        // Checkbox
        addSubview(checkbox)
        topAnchor.constraint(equalTo: checkbox.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: checkbox.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: checkbox.bottomAnchor).isActive = true
        checkbox.heightAnchor.constraint(equalTo: checkbox.widthAnchor).isActive = true
        
        // Title label
        addSubview(titleLabel)
        checkbox.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        
        // Menu button
        addSubview(menuButton)
        centerYAnchor.constraint(equalTo: menuButton.centerYAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: menuButton.leadingAnchor).isActive = true
        topAnchor.constraint(equalTo: menuButton.topAnchor, constant: -innerPadding).isActive = true
        bottomAnchor.constraint(equalTo: menuButton.bottomAnchor, constant: innerPadding).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 128).isActive = true
        
        menuButton.menu = menu
        menuButton.showsMenuAsPrimaryAction = true
        setMenuButtonTitle("Stack")
        
        // Apply button
        addSubview(applyButton)
        menuButton.trailingAnchor.constraint(equalTo: applyButton.leadingAnchor, constant: -10).isActive = true
        trailingAnchor.constraint(equalTo: applyButton.trailingAnchor, constant: innerPadding).isActive = true
        centerYAnchor.constraint(equalTo: applyButton.centerYAnchor).isActive = true
        topAnchor.constraint(equalTo: applyButton.topAnchor, constant: -innerPadding).isActive = true
        bottomAnchor.constraint(equalTo: applyButton.bottomAnchor, constant: innerPadding).isActive = true
        applyButton.widthAnchor.constraint(equalToConstant: 64).isActive = true

    }
    
    func setMenuButtonTitle(_ titleString: String) {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium, scale: .medium)
        let image = UIImage(systemName: "arrow.up.and.down", withConfiguration: imageConfig)!.withTintColor(.white.withAlphaComponent(0.4))
        let imageAttachment = NSTextAttachment(image: image)
        let attributes: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: UIColor.white,
            .baselineOffset : 1
        ]
        let fullString = NSMutableAttributedString(string: "\(titleString)  ", attributes: attributes)
        fullString.append(NSAttributedString(attachment: imageAttachment))
        menuButton.setAttributedTitle(fullString, for: .normal)
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.layoutDidChangePassthrough?(previousTraitCollection)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutDidChangePassthrough?(nil)
    }
    
    // MARK: Checkbox
    
    class CheckBox: UIButton {
        
        // Images
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .medium)
        var checkedImage: UIImage? {
            return UIImage(systemName: "checkmark.square.fill", withConfiguration: imageConfig)?.withTintColor(.white)
        }
        var uncheckedImage: UIImage? {
            return UIImage(systemName: "square", withConfiguration: imageConfig)?.withTintColor(.white)
        }
            
        // Bool property
        var isChecked: Bool = false {
            didSet {
                if isChecked == true {
                    self.setImage(checkedImage, for: .normal)
                } else {
                    self.setImage(uncheckedImage, for: .normal)
                }
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            initialize()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            initialize()
        }
        
        private func initialize() {
            self.translatesAutoresizingMaskIntoConstraints = false
            self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
            self.isChecked = false
            self.tintColor = .white
        }
            
        @objc func buttonClicked(sender: UIButton) {
            if sender == self {
                isChecked = !isChecked
            }
        }
    }
    
}


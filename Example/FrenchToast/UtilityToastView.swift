//
//  BulkActionToastView.swift
//
//  Copyright (c) 2023 Oak Studios.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without limitation in the rights to use, copy, modify, merge,
//  publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  The Software may not be used in applications and services that are used for or
//  aid in the exploration, extraction, refinement, processing, or transportation
//  of fossil fuels.
//
//  The Software may not be used by companies that rely on fossil fuel extraction
//  as their primary means of revenue. This includes but is not limited to the
//  companies listed at https://climatestrike.software/blocklist
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

import FrenchToast

class UtilityToastView: ToastView {
    
    var didTapApplyButton: (() -> Void)?
            
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
    
    override init(configuration: ToastConfiguration) {
        super.init(configuration: configuration)
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
        
        if #available(iOS 14.0, *) {
            menuButton.menu = menu
            menuButton.showsMenuAsPrimaryAction = true
        }
        
        setMenuButtonTitle("Stack")
        
        // Apply button
        addSubview(applyButton)
        menuButton.trailingAnchor.constraint(equalTo: applyButton.leadingAnchor, constant: -10).isActive = true
        trailingAnchor.constraint(equalTo: applyButton.trailingAnchor, constant: innerPadding).isActive = true
        centerYAnchor.constraint(equalTo: applyButton.centerYAnchor).isActive = true
        topAnchor.constraint(equalTo: applyButton.topAnchor, constant: -innerPadding).isActive = true
        bottomAnchor.constraint(equalTo: applyButton.bottomAnchor, constant: innerPadding).isActive = true
        applyButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        
        applyButton.addTarget(self, action: #selector(didTapApplyButton(sender:)), for: .touchUpInside)

    }
    
    @objc func didTapApplyButton(sender: UIButton) {
        self.didTapApplyButton?()
    }
    
    func setMenuButtonTitle(_ titleString: String) {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium, scale: .small)
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
        var isChecked: Bool = true {
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
            self.isChecked = true
            self.tintColor = .white
        }
            
        @objc func buttonClicked(sender: UIButton) {
            if sender == self {
                isChecked = !isChecked
            }
        }
    }
    
}


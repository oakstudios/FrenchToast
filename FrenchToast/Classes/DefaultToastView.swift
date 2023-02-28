//
//  DefaultToastView.swift
//  FrenchToast
//
//  Created by Alex Givens on 2/10/23.
//

import UIKit

public class DefaultToastView: UIView, ToastView {
    
    public let identifier = "DefaultToast.identifier"
    
//    public var duration: TimeInterval = ToastManager.shared.duration
    
//    public var position: ToastPosition = ToastManager.shared.position
        
    public var traitCollectionDidChangePassthrough: ((UITraitCollection?) -> Void)?
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.traitCollectionDidChangePassthrough?(previousTraitCollection)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.traitCollectionDidChangePassthrough?(nil)
    }
    
}

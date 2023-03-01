//
//  DefaultToastView.swift
//  FrenchToast
//
//  Created by Alex Givens on 2/10/23.
//

import UIKit

public class DefaultToastView: UIView, ToastView {
        
    public var layoutDidChangePassthrough: ((UITraitCollection?) -> Void)?
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.layoutDidChangePassthrough?(previousTraitCollection)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutDidChangePassthrough?(nil)
    }
    
}

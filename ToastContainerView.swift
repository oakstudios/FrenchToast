//
//  ToastContainerView.swift
//  FrenchToast
//
//  Created by Alex Givens on 2/13/23.
//

import UIKit

/**
 `ToastContainerView` is used to draw the toast inside for animation, as well as identifying frame changes.
*/
class ToastContainerView: UIView {
    
    var shouldRedrawFrame: (() -> Void)?
        
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        shouldRedrawFrame?()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        shouldRedrawFrame?()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
    
}
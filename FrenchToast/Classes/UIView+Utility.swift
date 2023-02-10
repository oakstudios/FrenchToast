//
//  UIView+Utility.swift
//  FrenchToast
//
//  Created by Alex Givens on 2/10/23.
//

import UIKit

extension UIView {
    
    var allSubviews: [UIView] {
        return self.subviews.flatMap { [$0] + $0.allSubviews }
    }
    
}

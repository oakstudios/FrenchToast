//
//  UIView+Utility.swift
//  FrenchToast
//
//  Created by Alex Givens on 2/10/23.
//

import UIKit

extension UIView {
    
    func traverseSubviewsAndFindType<T>(type: T.Type) -> T? {
        for case let result as T in self.allSubviews {
            return result
        }
        return nil
    }
    
    var allSubviews: [UIView] {
        return self.subviews.flatMap { [$0] + $0.allSubviews }
    }
    
}

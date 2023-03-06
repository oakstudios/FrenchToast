//
//  ToastPosition.swift
//  FrenchToast
//
//  Created by Alex Givens on 2/13/23.
//

import UIKit

public enum ToastHorizontalAlignment: Int {
    
    case right
    case center
    case left
    
    public func originCoordinate(forToast toast: UIView, inSuperview superview: UIView) -> Double {
        
        let configuration = toast.toastConfiguration ?? ToastConfiguration.sharedDefault
        let size = configuration.size(forToast: toast, inSuperView: superview)
        let horizontalMargin = superview.isCompact ? configuration.horizontalMarginForCompactSizeClass : configuration.horizontalMarginForRegularSizeClass
        
        if
            configuration.adjustWidthForCompactSizeClass,
            superview.traitCollection.horizontalSizeClass == .compact
        {
            return horizontalMargin
        }
        
        switch self {
            
        case .left:
            
            if superview.safeAreaInsets.left > 0 {
                return superview.safeAreaInsets.left
            }
            
            return horizontalMargin
            
        case .center:
            
            return (superview.frame.width / 2) - (size.width / 2)
            
        case .right:
            
            if superview.safeAreaInsets.right > 0 {
                return superview.frame.width - superview.safeAreaInsets.right - size.width
            }
            
            return superview.frame.width - horizontalMargin - size.width
            
        }
    }
    
}

public enum ToastVerticalAlignment: Int {
    
    case top
    case center
    case bottom
    
    public func originCoordinate(forToast toast: UIView, inSuperview superview: UIView) -> Double {
        
        let configuration = toast.toastConfiguration ?? ToastConfiguration.sharedDefault
        let size = configuration.size(forToast: toast, inSuperView: superview)
        let verticalMargin = superview.isCompact ? configuration.verticalMarginForCompactSizeClass : configuration.verticalMarginForRegularSizeClass
        
        switch self {
            
        case .top:
            
            var topInset = verticalMargin
            
            if
                configuration.appearOverTopAndBottomBars,
                let navBar = superview.traverseSubviewsAndFindType(type: UINavigationBar.self),
                navBar.isHidden == false
            {
                topInset += navBar.frame.maxY
            } else {
                topInset += superview.safeAreaInsets.top
            }
                        
            return topInset
            
        case .center:
            
            return (superview.frame.size.height / 2) - (size.height / 2)
            
        case .bottom:
            
            var bottomInset = verticalMargin + size.height
                        
            if
                configuration.appearOverTopAndBottomBars,
                let tabBar = superview.traverseSubviewsAndFindType(type: UITabBar.self),
                tabBar.isHidden == false
            {
                bottomInset += (superview.frame.size.height - tabBar.frame.minY)
            } else if
                configuration.appearOverTopAndBottomBars,
                let toolbar = superview.traverseSubviewsAndFindType(type: UIToolbar.self),
                toolbar.isHidden == false
            {
                bottomInset += (superview.frame.size.height - toolbar.frame.minY)
            } else {
                bottomInset += superview.safeAreaInsets.bottom
            }
                                                    
            return superview.frame.height - bottomInset
            
        }
    }
    
}

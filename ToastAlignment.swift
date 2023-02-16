//
//  ToastPosition.swift
//  FrenchToast
//
//  Created by Alex Givens on 2/13/23.
//

import UIKit

public struct FTAlignment {
    
    public var horizontal: FTHorizontalAlignment
    public var vertical: FTVerticalAlignment
    
    public func centerPoint(forToast toast: UIView, inSuperView superview: UIView) -> CGPoint {
        
        let x = horizontal.coordinate(forToast: toast, inSuperview: superview)
        let y = vertical.coordinate(forToast: toast, inSuperview: superview)
        return CGPoint(x: x, y: y)
        
    }
    
}

public enum FTHorizontalAlignment: Int {
    
    case right
    case center
    case left
    
    public func coordinate(forToast toast: UIView, inSuperview superview: UIView) -> Double {
        
        // For compact horizontal size classes, always center the view
        if superview.traitCollection.horizontalSizeClass == .compact {
            return superview.bounds.size.width / 2.0
        }
        
        switch self {
            
        case .right:
            
            var rightInset = toast.toastConfiguration?.horizontalMargin ?? ToastConfiguration.sharedDefault.horizontalMargin
            rightInset += superview.safeAreaInsets.right
            return rightInset + (toast.frame.size.width / 2.0)
            
        case .center:
            
            return superview.bounds.size.width / 2.0
            
        case .left:
                    
            var leftInset = toast.toastConfiguration?.horizontalMargin ?? ToastConfiguration.sharedDefault.horizontalMargin
            leftInset += superview.safeAreaInsets.left
            return superview.bounds.size.width - (toast.frame.size.width / 2.0) - leftInset
            
        }
    }
    
}

public enum FTVerticalAlignment: Int {
    
    case top
    case center
    case bottom
    
    public func coordinate(forToast toast: UIView, inSuperview superview: UIView) -> Double {
        
        switch self {
            
        case .top:
            
            var topInset = toast.toastConfiguration?.verticalMargin ?? ToastConfiguration.sharedDefault.verticalMargin
            
            if
                let navBar = superview.traverseSubviewsAndFindType(type: UINavigationBar.self),
                navBar.isHidden == false
            {
                topInset += navBar.frame.maxY
            } else {
                topInset += superview.safeAreaInsets.top
            }
            
            return topInset
            
        case .center:
            
            return superview.bounds.size.height / 2.0
            
        case .bottom:
                    
            var bottomInset = toast.toastConfiguration?.verticalMargin ?? ToastConfiguration.sharedDefault.verticalMargin
                        
            if
                let tabBar = superview.traverseSubviewsAndFindType(type: UITabBar.self),
                tabBar.isHidden == false
            {
                bottomInset += (superview.bounds.size.height - tabBar.frame.minY)
            } else if
                let toolbar = superview.traverseSubviewsAndFindType(type: UIToolbar.self),
                toolbar.isHidden == false
            {
                bottomInset += (superview.bounds.size.height - toolbar.frame.minY)
            } else {
                bottomInset += superview.safeAreaInsets.bottom
            }
                                                    
            return bottomInset
            
        }
    }
    
}

public enum ToastPosition {
    
    case top
    case center
    case bottom
    
    public func centerPoint(forToast toast: UIView, inSuperview superview: UIView) -> CGPoint {
        
        switch self {
            
        case .top:
            let alignment = FTAlignment(horizontal: .center, vertical: .bottom)
            var topPadding: CGFloat = ToastManager.shared.style.verticalPadding
            
            if
                let navBar = superview.traverseSubviewsAndFindType(type: UINavigationBar.self),
                navBar.isHidden == false
            {
                topPadding += navBar.frame.maxY
            } else {
                topPadding += superview.safeAreaInsets.top
            }
            
            let x = superview.bounds.size.width / 2.0
            let y = (toast.frame.size.height / 2.0) + topPadding
            
            return CGPoint(x: x, y: y)
            
        case .center:
            
            return CGPoint(x: superview.bounds.size.width / 2.0, y: superview.bounds.size.height / 2.0)
            
        case .bottom:
                    
            var bottomPadding: CGFloat = ToastManager.shared.style.verticalPadding
                        
            if
                let tabBar = superview.traverseSubviewsAndFindType(type: UITabBar.self),
                tabBar.isHidden == false
            {
                bottomPadding += (superview.bounds.size.height - tabBar.frame.minY)
            } else if
                let toolbar = superview.traverseSubviewsAndFindType(type: UITabBar.self),
                toolbar.isHidden == false
            {
                bottomPadding += (superview.bounds.size.height - toolbar.frame.minY)
            } else {
                bottomPadding += superview.safeAreaInsets.bottom
            }
                                                    
            // Center the toast by default
            var x = superview.bounds.size.width / 2.0
            if // In landscape / regular class sizes, pin to the right
                superview.traitCollection.horizontalSizeClass != .compact
//                let screenBounds = superview.window?.windowScene?.screen.bounds,
//                screenBounds.width > screenBounds.height
            {
                var horizontalMargin: CGFloat = 24
                let rightInset = superview.safeAreaInsets.right
                if rightInset > 0 {
                    horizontalMargin = rightInset
                }
                x = superview.bounds.size.width - (toast.frame.size.width / 2.0) - horizontalMargin
            }

            let y = (superview.bounds.size.height - (toast.frame.size.height / 2.0)) - bottomPadding
                    
            return CGPoint(x: x, y: y)
            
        }
    }
}

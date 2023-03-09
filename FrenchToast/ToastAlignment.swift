//
//  ToastPosition.swift
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

public enum ToastHorizontalAlignment: Int {
    
    /// Align to the right of the containing view, respecting `ToastConfiguration.horizontalMarginForCompactSizeClass` and `ToastConfiguration.horizontalMarginForRegularSizeClass`, as well as `safeAreaInset.right`.
    case right
    
    /// Align to the center of the containing view.
    case center
    
    /// Align to the left of the containing view, respecting `ToastConfiguration.horizontalMarginForCompactSizeClass` and `ToastConfiguration.horizontalMarginForRegularSizeClass`, as well as `safeAreaInset.left`.
    case left
    
    internal func originCoordinate(forToast toast: ToastView, inSuperview superview: UIView) -> Double {
        
        let configuration = toast.configuration
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
    
    public func originCoordinate(forToast toast: ToastView, inSuperview superview: UIView) -> Double {
        
        let configuration = toast.configuration
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

//
//  ToastConfiguration.swift
//  FrenchToast
//
//  Created by Alex Givens on 2/15/23.
//

import UIKit

/**
 `ToastStyle` instances define the look and feel for toast views created via the
 `makeToast` methods as well for toast views created directly with
 `toastViewForMessage(message:title:image:style:)`.

 @warning `ToastStyle` offers relatively simple styling options for the default
 toast view. If you require a toast view with more complex UI, it probably makes more
 sense to create your own custom UIView subclass and present it with the `showToast`
 methods.
*/
public struct ToastConfiguration {

    public init() {}
    
    /**
     The `ToastConfiguration` singleton instance for default values.
     
     */
    public static let sharedDefault = ToastConfiguration()
    
    
//    public var horizontalMargin: CGFloat = 10.0
    
    public var horizontalMarginForCompactSizeClass: CGFloat = 12.0
    public var horizontalMarginForRegularSizeClass: CGFloat = 24.0
    
    /**
     The spacing from the vertical edge of the toast view to the content. When a title
     is present, this is also used as the padding between the title and the message.
     Default is 10.0. On iOS11+, this value is added added to the `safeAreaInset.top`
     and `safeAreaInsets.bottom`.
    */
//    public var verticalMargin: CGFloat = 10.0
    
    public var verticalMarginForCompactSizeClass: CGFloat = 12.0
    public var verticalMarginForRegularSizeClass: CGFloat = 24.0
    
    /**
     The default duration. Used for the `makeToast` and
     `showToast` methods that don't require an explicit duration.
     Default is 3.0.
     */
    public var duration: ToastDuration = .definite(3.0)
    
    /**
     The fade in/out animation duration. Default is 0.2.
     */
    public var fadeDuration: TimeInterval = 0.2
    
    /**
     Enables or disables tap to dismiss on toast views. Default is `true`.
     
     */
    public var isTapToDismissEnabled = true
    
    // Size
    
    public var adjustWidthForCompactSizeClass = true
    
    public var suggestedSizeForCompactSizeClass = CGSize(width: 350, height: 48)
    
    public var suggestedSizeForRegularSizeClass = CGSize(width: 400, height: 64)
    
    // Alignment
    
    public var appearOverTopAndBottomBars = true
    
    public var horizontalAlignment: ToastHorizontalAlignment = .center
    
    public var verticalAlignment: ToastVerticalAlignment = .bottom
    
}

extension ToastConfiguration {
    
    func frame(forToast toast: UIView, inSuperView superview: UIView) -> CGRect {
        let origin = origin(forToast: toast, inSuperView: superview)
        let size = size(forToast: toast, inSuperView: superview)
        return CGRect(origin: origin, size: size)
    }
    
    func origin(forToast toast: UIView, inSuperView superview: UIView) -> CGPoint {
        
        let x = horizontalAlignment.originCoordinate(forToast: toast, inSuperview: superview)
        let y = verticalAlignment.originCoordinate(forToast: toast, inSuperview: superview)
        return CGPoint(x: x, y: y)
        
    }
    
    func size(forToast toast: UIView, inSuperView superview: UIView) -> CGSize {
        
        if superview.traitCollection.horizontalSizeClass == .compact || superview.traitCollection.verticalSizeClass == .compact {
            
            if adjustWidthForCompactSizeClass, superview.traitCollection.horizontalSizeClass == .compact {
                let adjustedWidth = superview.frame.width - (horizontalMarginForCompactSizeClass * 2) - superview.safeAreaInsets.left - superview.safeAreaInsets.right
                let adjustedSize = CGSize(width: adjustedWidth, height: suggestedSizeForCompactSizeClass.height)
                return adjustedSize
            }
            
            return suggestedSizeForCompactSizeClass
            
        } else {
            
            return suggestedSizeForRegularSizeClass
            
        }
        
    }
    
}

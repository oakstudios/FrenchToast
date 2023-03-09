//
//  ToastConfiguration.swift
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
    
    /**
     The duration to show the view before dismissing. Choose either an indefinite or definite amount of time. Default is a definite 3.0 seconds.
     */
    public var duration: ToastDuration = .definite(time: 3.0)
    
    /**
     The fade in/out animation duration. Default is 0.2.
     */
    public var fadeDuration: TimeInterval = 0.2
    
    /**
     Enables or disables tap to dismiss on toast views. Default is `true`.
     */
    public var isTapToDismissEnabled = true
    
    // MARK: Margin
    
    /**
     The spacing from the horizontal edge of the toast view to the content, when compact sizing is detected. Default is 12.0. This value is added added to the `safeAreaInset.left`
     and `safeAreaInsets.right`.
    */
    public var horizontalMarginForCompactSizeClass: CGFloat = 12.0
    
    /**
     The spacing from the horizontal edge of the toast view to the content, when regular sizing is detected. Default is 24.0. This value is added added to the `safeAreaInset.left`
     and `safeAreaInsets.right`.
    */
    public var horizontalMarginForRegularSizeClass: CGFloat = 24.0
    
    /**
     The spacing from the vertical edge of the toast view to the content, when compact sizing is detected. Default is 12.0. This value is added added to the `safeAreaInset.top`
     and `safeAreaInsets.bottom`, and if the `appearOverTopAndBottomBars` value is `true`, will also add the height of any `UINavigationBar`, `UITabBar`, or `UIToolbar` as necessary.
    */
    public var verticalMarginForCompactSizeClass: CGFloat = 12.0
    
    /**
     The spacing from the vertical edge of the toast view to the content, when regular sizing is detected. Default is 24.0. This value is added added to the `safeAreaInset.top`
     and `safeAreaInsets.bottom`, and if the `appearOverTopAndBottomBars` value is `true`, will also add the height of any `UINavigationBar`, `UITabBar`, or `UIToolbar` as necessary.
    */
    public var verticalMarginForRegularSizeClass: CGFloat = 24.0
    
    // MARK: Size
    
    /**
     When the horizontal size class of the presenting view is compact, override the `suggestedSizeForCompactSizeClass` and adjust the width to fill the superview. Default is `true`.
     */
    public var adjustWidthForCompactSizeClass = true
    
    /**
     The size to draw the toast view's frame when either the vertical or horizontal size class of the superview is compact. May be override if `adjustWidthForCompactSizeClass` is `true`. Defaults to a width of 350.0 and a height of 48.0.
     */
    public var suggestedSizeForCompactSizeClass = CGSize(width: 350, height: 48)
    
    /**
     The size to draw the toast view's frame when either the vertical or horizontal size class of the superview is regular. Defaults to a width of 400.0 and a height of 64.0.
     */
    public var suggestedSizeForRegularSizeClass = CGSize(width: 400, height: 64)
    
    // MARK: Alignment
    
    /**
     This value determines if the toast view's frame should be drawn with respect to any `UINavigationBar`, `UITabBar`, or `UIToolbar` detected within the superview. Default is `true`.
     */
    public var appearOverTopAndBottomBars = true
    
    /**
     The horizontal alignment (left, right, or center), to render the toast view.
     */
    public var horizontalAlignment: ToastHorizontalAlignment = .center
    
    /**
     The vertical alignment (left, right, or center), to render the toast view.
     */
    public var verticalAlignment: ToastVerticalAlignment = .bottom
    
}

extension ToastConfiguration {
    
    internal func frame(forToast toast: ToastView, inSuperView superview: UIView) -> CGRect {
        let origin = origin(forToast: toast, inSuperView: superview)
        let size = size(forToast: toast, inSuperView: superview)
        return CGRect(origin: origin, size: size)
    }
    
    internal func origin(forToast toast: ToastView, inSuperView superview: UIView) -> CGPoint {
        
        let x = horizontalAlignment.originCoordinate(forToast: toast, inSuperview: superview)
        let y = verticalAlignment.originCoordinate(forToast: toast, inSuperview: superview)
        return CGPoint(x: x, y: y)
        
    }
    
    internal func size(forToast toast: ToastView, inSuperView superview: UIView) -> CGSize {
        
        if superview.traitCollection.horizontalSizeClass == .compact || superview.traitCollection.verticalSizeClass == .compact {
            
            if
                adjustWidthForCompactSizeClass,
                superview.traitCollection.horizontalSizeClass == .compact
            {
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

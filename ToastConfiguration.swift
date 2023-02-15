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
    
    
    public var horizontalMargin: CGFloat = 10.0
    
    /**
     The spacing from the vertical edge of the toast view to the content. When a title
     is present, this is also used as the padding between the title and the message.
     Default is 10.0. On iOS11+, this value is added added to the `safeAreaInset.top`
     and `safeAreaInsets.bottom`.
    */
    public var verticalMargin: CGFloat = 10.0
    
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
    
    public var horizontalAlignment: FTHorizontalAlignment = .center
    
    public var verticalAlignment: FTVerticalAlignment = .bottom

    public var alignment: FTAlignment = FTAlignment(horizontal: .center, vertical: .bottom)
    
    public var appearOverTopAndBottomBars = true
    
}

//
//  UIView+Toast.swift
//
//  Copyright (c) 2023 Oak Studios.
//  Copyright (c) 2015-2019 Charles Scalesse.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be included
//  in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit
import ObjectiveC

/**
 Toast is a Swift extension that adds toast notifications to the `UIView` object class.
 It is intended to be simple, lightweight, and easy to use. Most toast notifications
 can be triggered with a single line of code.
 
 The `makeToast` methods create a new view and then display it as toast.
 
 The `showToast` methods display any view as toast.
 
 */
public extension UIView {
    
    /**
     Keys used for associated objects.
     */
    private struct ToastKeys {
        static var timer        = "com.toast-swift.timer"
        static var duration     = "com.toast-swift.duration"
        static var point        = "com.toast-swift.point"
        static var didTap       = "com.toast-swift.didTap"
        static var completion   = "com.toast-swift.completion"
        static var activeToasts = "com.toast-swift.activeToasts"
        static var activityView = "com.toast-swift.activityView"
        static var queue        = "com.toast-swift.queue"
        static var configuration = "com.toast-swift.configuration"
    }
    
    /**
     Swift closures can't be directly associated with objects via the
     Objective-C runtime, so the (ugly) solution is to wrap them in a
     class that can be used with associated objects.
     */
    private class ToastConfigurationWrapper {
        let toastConfiguration: ToastConfiguration?
        
        init(_ toastConfiguration: ToastConfiguration?) {
            self.toastConfiguration = toastConfiguration
        }
    }
    
    /**
     Swift closures can't be directly associated with objects via the
     Objective-C runtime, so the (ugly) solution is to wrap them in a
     class that can be used with associated objects.
     */
    private class ToastCompletionWrapper {
        let completion: ((Bool) -> Void)?
        
        init(_ completion: ((Bool) -> Void)?) {
            self.completion = completion
        }
    }
    
    private class ToastDidTapWrapper {
        let didTap: (() -> Void)?
        
        init(_ didTap: (() -> Void)?) {
            self.didTap = didTap
        }
    }
    
    private enum ToastError: Error {
        case missingParameters
    }
    
//    private let trackingView: TouchPassthroughView = {
//        let view = TouchPassthroughView()
//        view.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
//        view.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
//        view.backgroundColor = .clear
//        return view
//    }()
    
    var toastConfiguration: ToastConfiguration? {
        get {
            if let configuration = objc_getAssociatedObject(self, &ToastKeys.configuration) as? ToastConfiguration {
                return configuration
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self, &ToastKeys.configuration, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var activeToasts: NSMutableArray {
        get {
            if let activeToasts = objc_getAssociatedObject(self, &ToastKeys.activeToasts) as? NSMutableArray {
                return activeToasts
            } else {
                let activeToasts = NSMutableArray()
                objc_setAssociatedObject(self, &ToastKeys.activeToasts, activeToasts, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return activeToasts
            }
        }
    }
    
    private var queue: NSMutableArray {
        get {
            if let queue = objc_getAssociatedObject(self, &ToastKeys.queue) as? NSMutableArray {
                return queue
            } else {
                let queue = NSMutableArray()
                objc_setAssociatedObject(self, &ToastKeys.queue, queue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return queue
            }
        }
    }
    
    // MARK: - Make Toast Methods
    
    /**
     Creates and presents a new toast view.
     
     @param message The message to be displayed
     @param duration The toast duration
     @param position The toast's position
     @param title The title
     @param image The image
     @param style The style. The shared style will be used when nil
     @param completion The completion closure, executed after the toast view disappears.
            didTap will be `true` if the toast view was dismissed from a tap.
     */
//    func makeToast(_ message: String?, duration: TimeInterval = ToastManager.shared.duration, position: ToastPosition = ToastManager.shared.position, title: String? = nil, image: UIImage? = nil, style: ToastStyle = ToastManager.shared.style, completion: ((_ didTap: Bool) -> Void)? = nil) {
//        do {
//            let toast = try toastViewForMessage(message, title: title, image: image, style: style)
//            let point = position.centerPoint(forToast: toast, inSuperview: self)
//            showToast(toast, duration: duration, point: point, completion: completion)
//        } catch ToastError.missingParameters {
//            print("Error: message, title, and image are all nil")
//        } catch {}
//    }
    
    /**
     Creates a new toast view and presents it at a given center point.
     
     @param message The message to be displayed
     @param duration The toast duration
     @param point The toast's center point
     @param title The title
     @param image The image
     @param style The style. The shared style will be used when nil
     @param completion The completion closure, executed after the toast view disappears.
            didTap will be `true` if the toast view was dismissed from a tap.
     */
//    func makeToast(_ message: String?, duration: TimeInterval = ToastManager.shared.duration, point: CGPoint, title: String?, image: UIImage?, style: ToastStyle = ToastManager.shared.style, completion: ((_ didTap: Bool) -> Void)?) {
//        do {
//            let toast = try toastViewForMessage(message, title: title, image: image, style: style)
//            showToast(toast, duration: duration, point: point, completion: completion)
//        } catch ToastError.missingParameters {
//            print("Error: message, title, and image cannot all be nil")
//        } catch {}
//    }
    
    // MARK: - Show Toast Methods
    
    /**
     Displays any view as toast at a provided position and duration. The completion closure
     executes when the toast view completes. `didTap` will be `true` if the toast view was
     dismissed from a tap.
     
     @param toast The view to be displayed as toast
     @param duration The notification duration
     @param position The toast's position
     @param completion The completion block, executed after the toast view disappears.
     didTap will be `true` if the toast view was dismissed from a tap.
     */
    func showToast(_ toast: ToastView, didTap: (() -> Void)? = nil, completion: ((_ didTap: Bool) -> Void)? = nil) {
//        let configuration = toast.toastConfiguration ?? ToastConfiguration.sharedDefault
//        let point = configuration.alignment.centerPoint(forToast: toast, inSuperView: self)
//        let duration = configuration.duration
//        showToast(toast, duration: duration, point: point, didTap: didTap, completion: completion)
        showToast(toast)
    }
    
    func clearDidTap(for toast: UIView) {
        objc_setAssociatedObject(toast, &ToastKeys.didTap, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    // position: ToastPosition = ToastManager.shared.position,
    
    /**
     Displays any view as toast at a provided center point and duration. The completion closure
     executes when the toast view completes. `didTap` will be `true` if the toast view was
     dismissed from a tap.
     
     @param toast The view to be displayed as toast
     @param duration The notification duration
     @param point The toast's center point
     @param completion The completion block, executed after the toast view disappears.
     didTap will be `true` if the toast view was dismissed from a tap.
     */
//    func showToast(_ toast: ToastView, duration: ToastDuration, point: CGPoint, didTap: (() -> Void)? = nil, completion: ((_ didTap: Bool) -> Void)? = nil) {
//
//        objc_setAssociatedObject(toast, &ToastKeys.didTap, ToastDidTapWrapper(didTap), .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        objc_setAssociatedObject(toast, &ToastKeys.completion, ToastCompletionWrapper(completion), .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//        if ToastManager.shared.isQueueEnabled, activeToasts.count > 0 {
////            objc_setAssociatedObject(toast, &ToastKeys.duration, NSNumber(value: duration), .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//            objc_setAssociatedObject(toast, &ToastKeys.point, NSValue(cgPoint: point), .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//            queue.add(toast)
//        } else {
//            showToast(toast, duration: duration, point: point)
//        }
//    }
    
    // MARK: - Hide Toast Methods
    
    /**
     Hides the active toast. If there are multiple toasts active in a view, this method
     hides the oldest toast (the first of the toasts to have been presented).
     
     @see `hideAllToasts()` to remove all active toasts from a view.
     
     @warning This method has no effect on activity toasts. Use `hideToastActivity` to
     hide activity toasts.
     
    */
    func hideToast() {
        guard let activeToast = activeToasts.firstObject as? ToastView else { return }
        hideToast(activeToast)
    }
    
    /**
     Hides an active toast.
     
     @param toast The active toast view to dismiss. Any toast that is currently being displayed
     on the screen is considered active.
     
     @warning this does not clear a toast view that is currently waiting in the queue.
     */
    func hideToast(_ toast: ToastView) {
        guard activeToasts.contains(toast) else { return }
        hideToast(toast, fromTap: false)
    }
    
    /**
     Hides all toast views.
     
     @param includeActivity If `true`, toast activity will also be hidden. Default is `false`.
     @param clearQueue If `true`, removes all toast views from the queue. Default is `true`.
    */
    func hideAllToasts(includeActivity: Bool = false, clearQueue: Bool = true) {
        if clearQueue {
            clearToastQueue()
        }
        
        activeToasts.compactMap { $0 as? ToastView }
                    .forEach { hideToast($0) }
        
//        if includeActivity {
//            hideToastActivity()
//        }
    }
    
    /**
     Removes all toast views from the queue. This has no effect on toast views that are
     active. Use `hideAllToasts(clearQueue:)` to hide the active toasts views and clear
     the queue.
     */
    func clearToastQueue() {
        queue.removeAllObjects()
    }
    
    // MARK: - Private Show/Hide Methods
    
    private func showToast(_ toast: ToastView) {
        
        let configuration = toast.toastConfiguration ?? ToastConfiguration.sharedDefault
        let point = configuration.alignment.centerPoint(forToast: toast, inSuperView: self)
        let duration = configuration.duration
        
        toast.center = point
        toast.alpha = 0.0
        
        if ToastManager.shared.isTapToDismissEnabled {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(UIView.handleToastTapped(_:)))
            toast.addGestureRecognizer(recognizer)
            toast.isUserInteractionEnabled = true
            toast.isExclusiveTouch = true
        }
        
        toast.traitCollectionDidChangePassthrough = { [weak self] previousTraitCollection in
            guard
//                let superview = self.superview,
                let self = self,
                let alignment = toast.toastConfiguration?.alignment
            else { return }
            
            toast.center = alignment.centerPoint(forToast: toast, inSuperView: self)
//            toast.center = toast.position.centerPoint(forToast: toast, inSuperview: superview)
        }
        
        activeToasts.add(toast)
        self.addSubview(toast)
        
        switch duration {
            
        case .indefinite:
            
            UIView.animate(withDuration: configuration.fadeDuration, delay: 0.0, options: [.curveEaseOut, .allowUserInteraction], animations: {
                toast.alpha = 1.0
            })
            
        case .definite(let timeInterval):
            
            
            UIView.animate(withDuration: configuration.fadeDuration, delay: 0.0, options: [.curveEaseOut, .allowUserInteraction], animations: {
                toast.alpha = 1.0
            }) { _ in
                let timer = Timer(timeInterval: timeInterval, target: self, selector: #selector(UIView.toastTimerDidFinish(_:)), userInfo: toast, repeats: false)
                RunLoop.main.add(timer, forMode: .commonModes)
                objc_setAssociatedObject(toast, &ToastKeys.timer, timer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            
        }
        
//        if duration == 0 {
//
//            UIView.animate(withDuration: ToastManager.shared.style.fadeDuration, delay: 0.0, options: [.curveEaseOut, .allowUserInteraction], animations: {
//                toast.alpha = 1.0
//            })
//
//        } else {
//            UIView.animate(withDuration: ToastManager.shared.style.fadeDuration, delay: 0.0, options: [.curveEaseOut, .allowUserInteraction], animations: {
//                toast.alpha = 1.0
//            }) { _ in
//                let timer = Timer(timeInterval: duration, target: self, selector: #selector(UIView.toastTimerDidFinish(_:)), userInfo: toast, repeats: false)
//                RunLoop.main.add(timer, forMode: .commonModes)
//                objc_setAssociatedObject(toast, &ToastKeys.timer, timer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            }
//        }
        
    }
    
    private func hideToast(_ toast: ToastView, fromTap: Bool) {
        
        let configuration = toast.toastConfiguration ?? ToastConfiguration.sharedDefault
        
        if let timer = objc_getAssociatedObject(toast, &ToastKeys.timer) as? Timer {
            timer.invalidate()
        }
        
        UIView.animate(withDuration: configuration.fadeDuration, delay: 0.0, options: [.curveEaseIn, .beginFromCurrentState], animations: {
            toast.alpha = 0.0
        }) { _ in
            toast.removeFromSuperview()
            self.activeToasts.remove(toast)
            
            if let wrapper = objc_getAssociatedObject(toast, &ToastKeys.completion) as? ToastCompletionWrapper, let completion = wrapper.completion {
                completion(fromTap)
            }
            
            if let nextToast = self.queue.firstObject as? ToastView {
                self.showToast(nextToast)
            }
            
//            if let nextToast = self.queue.firstObject as? ToastView, let duration = objc_getAssociatedObject(nextToast, &ToastKeys.duration) as? NSNumber, let point = objc_getAssociatedObject(nextToast, &ToastKeys.point) as? NSValue {
//                self.queue.removeObject(at: 0)
//                self.showToast(nextToast, duration: .definite(duration.doubleValue), point: point.cgPointValue)
//            }
        }
    }
    
    // MARK: - Events
    
    @objc
    private func handleToastTapped(_ recognizer: UITapGestureRecognizer) {
        guard let toast = recognizer.view as? ToastView else { return }
        
        if
            let didTapWrapper = objc_getAssociatedObject(toast, &ToastKeys.didTap) as? ToastDidTapWrapper,
            let didTap = didTapWrapper.didTap
        {
            didTap()
        } else {
            hideToast(toast, fromTap: true)
        }
        
    }
    
    @objc
    private func toastTimerDidFinish(_ timer: Timer) {
        guard let toast = timer.userInfo as? ToastView else { return }
        hideToast(toast)
    }
    
    // MARK: - Toast Construction
    
    /**
     Creates a new toast view with any combination of message, title, and image.
     The look and feel is configured via the style. Unlike the `makeToast` methods,
     this method does not present the toast view automatically. One of the `showToast`
     methods must be used to present the resulting view.
    
     @warning if message, title, and image are all nil, this method will throw
     `ToastError.missingParameters`
    
     @param message The message to be displayed
     @param title The title
     @param image The image
     @param style The style. The shared style will be used when nil
     @throws `ToastError.missingParameters` when message, title, and image are all nil
     @return The newly created toast view
    */
    func toastViewForMessage(_ message: String?, title: String?, image: UIImage?, style: ToastStyle) throws -> ToastView {
        // sanity
        guard message != nil || title != nil || image != nil else {
            throw ToastError.missingParameters
        }
        
        var messageLabel: UILabel?
        var titleLabel: UILabel?
        var imageView: UIImageView?
        
        let wrapperView = DefaultToastView()
        wrapperView.backgroundColor = style.backgroundColor
        wrapperView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        wrapperView.layer.cornerRadius = style.cornerRadius
        
        if style.displayShadow {
            wrapperView.layer.shadowColor = UIColor.black.cgColor
            wrapperView.layer.shadowOpacity = style.shadowOpacity
            wrapperView.layer.shadowRadius = style.shadowRadius
            wrapperView.layer.shadowOffset = style.shadowOffset
        }
        
        if let image = image {
            imageView = UIImageView(image: image)
            imageView?.contentMode = .scaleAspectFit
            imageView?.frame = CGRect(x: style.horizontalPadding, y: style.verticalPadding, width: style.imageSize.width, height: style.imageSize.height)
        }
        
        var imageRect = CGRect.zero
        
        if let imageView = imageView {
            imageRect.origin.x = style.horizontalPadding
            imageRect.origin.y = style.verticalPadding
            imageRect.size.width = imageView.bounds.size.width
            imageRect.size.height = imageView.bounds.size.height
        }

        if let title = title {
            titleLabel = UILabel()
            titleLabel?.numberOfLines = style.titleNumberOfLines
            titleLabel?.font = style.titleFont
            titleLabel?.textAlignment = style.titleAlignment
            titleLabel?.lineBreakMode = .byTruncatingTail
            titleLabel?.textColor = style.titleColor
            titleLabel?.backgroundColor = UIColor.clear
            titleLabel?.text = title;
            
            let maxTitleSize = CGSize(width: (self.bounds.size.width * style.maxWidthPercentage) - imageRect.size.width, height: self.bounds.size.height * style.maxHeightPercentage)
            let titleSize = titleLabel?.sizeThatFits(maxTitleSize)
            if let titleSize = titleSize {
                titleLabel?.frame = CGRect(x: 0.0, y: 0.0, width: titleSize.width, height: titleSize.height)
            }
        }
        
        if let message = message {
            messageLabel = UILabel()
            messageLabel?.text = message
            messageLabel?.numberOfLines = style.messageNumberOfLines
            messageLabel?.font = style.messageFont
            messageLabel?.textAlignment = style.messageAlignment
            messageLabel?.lineBreakMode = .byTruncatingTail;
            messageLabel?.textColor = style.messageColor
            messageLabel?.backgroundColor = UIColor.clear
            
            let maxMessageSize = CGSize(width: (self.bounds.size.width * style.maxWidthPercentage) - imageRect.size.width, height: self.bounds.size.height * style.maxHeightPercentage)
            let messageSize = messageLabel?.sizeThatFits(maxMessageSize)
            if let messageSize = messageSize {
                let actualWidth = min(messageSize.width, maxMessageSize.width)
                let actualHeight = min(messageSize.height, maxMessageSize.height)
                messageLabel?.frame = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
            }
        }
  
        var titleRect = CGRect.zero
        
        if let titleLabel = titleLabel {
            titleRect.origin.x = imageRect.origin.x + imageRect.size.width + style.horizontalPadding
            titleRect.origin.y = style.verticalPadding
            titleRect.size.width = titleLabel.bounds.size.width
            titleRect.size.height = titleLabel.bounds.size.height
        }
        
        var messageRect = CGRect.zero
        
        if let messageLabel = messageLabel {
            messageRect.origin.x = imageRect.origin.x + imageRect.size.width + style.horizontalPadding
            messageRect.origin.y = titleRect.origin.y + titleRect.size.height + style.verticalPadding
            messageRect.size.width = messageLabel.bounds.size.width
            messageRect.size.height = messageLabel.bounds.size.height
        }
        
        let longerWidth = max(titleRect.size.width, messageRect.size.width)
        let longerX = max(titleRect.origin.x, messageRect.origin.x)
        let wrapperWidth = max((imageRect.size.width + (style.horizontalPadding * 2.0)), (longerX + longerWidth + style.horizontalPadding))
        let wrapperHeight = max((messageRect.origin.y + messageRect.size.height + style.verticalPadding), (imageRect.size.height + (style.verticalPadding * 2.0)))
        
        wrapperView.frame = CGRect(x: 0.0, y: 0.0, width: wrapperWidth, height: wrapperHeight)
        
        if let titleLabel = titleLabel {
            titleRect.size.width = longerWidth
            titleLabel.frame = titleRect
            wrapperView.addSubview(titleLabel)
        }
        
        if let messageLabel = messageLabel {
            messageRect.size.width = longerWidth
            messageLabel.frame = messageRect
            wrapperView.addSubview(messageLabel)
        }
        
        if let imageView = imageView {
            wrapperView.addSubview(imageView)
        }
        
        return wrapperView
    }
    
}

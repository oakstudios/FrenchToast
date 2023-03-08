//
//  UIView+Toast.swift
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
        static var didTap       = "com.toast-swift.didTap"
        static var completion   = "com.toast-swift.completion"
        static var activeToasts = "com.toast-swift.activeToasts"
        static var queue        = "com.toast-swift.queue"
        static var configuration = "com.toast-swift.configuration"
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
                
        toast.frame = configuration.frame(forToast: toast, inSuperView: self)
        toast.alpha = 0.0
        
        if configuration.isTapToDismissEnabled {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(UIView.handleToastTapped(_:)))
            toast.addGestureRecognizer(recognizer)
            toast.isUserInteractionEnabled = true
            toast.isExclusiveTouch = true
        }
        
        toast.layoutDidChangePassthrough = { previousTraitCollection in
            toast.frame = configuration.frame(forToast: toast, inSuperView: self)
        }
        
        activeToasts.add(toast)
        self.addSubview(toast)
        
        switch configuration.duration {
            
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
            
            if
                let wrapper = objc_getAssociatedObject(toast, &ToastKeys.completion) as? ToastCompletionWrapper,
                let completion = wrapper.completion
            {
                completion(fromTap)
            }
            
            if let nextToast = self.queue.firstObject as? ToastView {
                self.queue.removeObject(at: 0)
                self.showToast(nextToast)
            }
            
        }
    }
    
    // MARK: - Events
    
    @objc private func handleToastTapped(_ recognizer: UITapGestureRecognizer) {
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
    
}

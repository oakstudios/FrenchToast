//
//  ToastView.swift
//  FrenchToast
//
//  Created by Alex Givens on 2/10/23.
//

import UIKit

public protocol ToastView : UIView {
    var identifier: String { get }
    var duration: TimeInterval { get set }
    var position: ToastPosition { get set }
    var traitCollectionDidChangePassthrough: ((UITraitCollection?) -> Void)? { get set }
}

//
//  ToastView.swift
//  FrenchToast
//
//  Created by Alex Givens on 2/10/23.
//

import UIKit

public protocol ToastView : UIView {
    var layoutDidChangePassthrough: ((UITraitCollection?) -> Void)? { get set }
}

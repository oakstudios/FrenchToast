//
//  ViewController.swift
//  FrenchToast
//
//  Created by mail@alexgivens.com on 02/08/2023.
//  Copyright (c) 2023 mail@alexgivens.com. All rights reserved.
//

import UIKit
import FrenchToast

class ViewController: UIViewController {
    
    @IBOutlet weak var toastStyleSegmentedControl: UISegmentedControl!
    @IBOutlet weak var durationSegmentedControl: UISegmentedControl!
    @IBOutlet weak var horizontalSegmentedControl: UISegmentedControl!
    @IBOutlet weak var verticalSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapShowToast(_ sender: Any) {
        let toastView = createToastView()
        let didTap: (() -> Void) = {
            self.view.hideToast(toastView)
        }
        self.view.showToast(toastView, didTap: didTap)
    }
    
    func createToastView() -> ToastView {
        
        var width: CGFloat = 400
        var height: CGFloat = 64
        
        if
            UIDevice.current.userInterfaceIdiom == .phone,
            let bounds = view.window?.windowScene?.screen.bounds
        {
            let horizontalPadding: CGFloat = 10
            width = min(bounds.width, bounds.height) - (horizontalPadding * 2)
            height = 48
        }
        
        let size = CGSize(width: width, height: height)
        let frame = CGRect(origin: .zero, size: size)
        
        var configuration = ToastConfiguration()
        configuration.horizontalMargin = 32
        configuration.verticalMargin = 32
        
        switch durationSegmentedControl.selectedSegmentIndex {
        case 0: configuration.duration = .definite(3)
        default: configuration.duration = .indefinite
        }
        
        switch horizontalSegmentedControl.selectedSegmentIndex {
        case 0: configuration.horizontalAlignment = .left
        case 1: configuration.horizontalAlignment = .center
        default: configuration.horizontalAlignment = .right
        }
        
        switch verticalSegmentedControl.selectedSegmentIndex {
        case 0: configuration.verticalAlignment = .top
        case 1: configuration.verticalAlignment = .center
        default: configuration.verticalAlignment = .bottom
        }
        
        switch toastStyleSegmentedControl.selectedSegmentIndex {
            
        case 0:
            
            let defaultToastView = DefaultToastView(frame: frame)
            defaultToastView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
            defaultToastView.toastConfiguration = configuration
            defaultToastView.backgroundColor = .orange
            return defaultToastView
            
        default:
                        
            let musicToastView = MusicToastView(frame: frame)
            musicToastView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
            musicToastView.toastConfiguration = configuration
            musicToastView.imageView.image = UIImage(named: "MUNA")
            musicToastView.titleLabel.text = "Silk Chiffon"
            musicToastView.subtitleLabel.text = "MUNA, Phoebe Bridgers"
            musicToastView.progressView.progress = 0.25
            return musicToastView
            
        }
        
    }
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Standard item", image: UIImage(systemName: "sun.max"), handler: { (_) in
            }),
            UIAction(title: "Disabled item", image: UIImage(systemName: "moon"), attributes: .disabled, handler: { (_) in
            }),
            UIAction(title: "Delete..", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { (_) in
            })
        ]
    }

}


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
    @IBOutlet weak var positionSegmentedControl: UISegmentedControl!

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
        let horizontalPadding: CGFloat = 8
        var width: CGFloat = 400
        var height: CGFloat = 64
        if
            UIDevice.current.userInterfaceIdiom == .phone,
            let bounds = view.window?.windowScene?.screen.bounds
        {
            width = min(bounds.width, bounds.height) - (horizontalPadding * 2) - (16 / 2)
            height = 48
        }
        let size = CGSize(width: width, height: height)
        let frame = CGRect(origin: .zero, size: size)
        
        var toastView: ToastView!
        
        switch toastStyleSegmentedControl.selectedSegmentIndex {
        case 0:
            let defaultToastView = DefaultToastView(frame: frame)
            defaultToastView.backgroundColor = .orange
            toastView = defaultToastView
        default:
            let musicToastView = MusicToastView(frame: frame)
            musicToastView.imageView.image = UIImage(named: "MUNA")
            musicToastView.titleLabel.text = "Silk Chiffon"
            musicToastView.subtitleLabel.text = "MUNA, Phoebe Bridgers"
            musicToastView.progressView.progress = 0.25
            toastView = musicToastView
        }
        
        toastView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        
        switch durationSegmentedControl.selectedSegmentIndex {
        case 0: toastView.duration = 3
        default: toastView.duration = 0
        }
        
        switch positionSegmentedControl.selectedSegmentIndex {
        case 0: toastView.position = .top
        case 1: toastView.position = .center
        default: toastView.position = .bottom
        }
        
        return toastView
    }

}


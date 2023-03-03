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
        
        var configuration = ToastConfiguration()
        
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
            
            let notificationToastView = NotificationToastView()
            notificationToastView.toastConfiguration = configuration
            
            // Offline
            notificationToastView.backgroundColor = .red
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .medium)
            let image = UIImage(systemName: "icloud.slash", withConfiguration: imageConfig)
            notificationToastView.imageView.image = image
            notificationToastView.titleLabel.text = "You're offline"
            notificationToastView.actionButton.setTitle("Retry", for: .normal)
            
            return notificationToastView
            
        case 1:
            
            // Maintain larger height for compact view
            configuration.suggestedSizeForCompactSizeClass = CGSize(width: 400, height: 64)
            configuration.suggestedSizeForRegularSizeClass = CGSize(width: 500, height: 64)
            
            let utilityToastView = UtilityToastView()
            utilityToastView.toastConfiguration = configuration
            utilityToastView.titleLabel.text = "3 selected"
            return utilityToastView
            
        default:
            
            configuration.suggestedSizeForRegularSizeClass = CGSize(width: 550, height: 64)
            
            let musicToastView = MusicToastView()
            musicToastView.toastConfiguration = configuration
            musicToastView.imageView.image = UIImage(named: "MUNA")
            musicToastView.titleLabel.text = "Silk Chiffon"
            musicToastView.subtitleLabel.text = "MUNA, Phoebe Bridgers"
            musicToastView.progressView.progress = 0.25
            return musicToastView
            
        }
        
    }

}


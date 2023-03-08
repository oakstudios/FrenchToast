//
//  ViewController.swift
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
        case 0: configuration.duration = .definite(time: 3.0)
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
            
            let notificationToastView = NotificationToastView(configuration: configuration)
            
            // Offline
            notificationToastView.backgroundColor = .red
            let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .medium)
            let image = UIImage(systemName: "icloud.slash", withConfiguration: imageConfiguration)
            notificationToastView.imageView.image = image
            notificationToastView.titleLabel.text = "You're offline"
            notificationToastView.actionButton.setTitle("Retry", for: .normal)
            
            return notificationToastView
            
        case 1:
            
            // Adjust the sizing for Regular and Compact sizes for larger components
            configuration.suggestedSizeForCompactSizeClass = CGSize(width: 400, height: 64)
            configuration.suggestedSizeForRegularSizeClass = CGSize(width: 550, height: 64)
            
            let utilityToastView = UtilityToastView(configuration: configuration)
            utilityToastView.titleLabel.text = "3 selected"
            return utilityToastView
            
        default:
            
            configuration.suggestedSizeForRegularSizeClass = CGSize(width: 550, height: 64)
            
            let musicToastView = MusicToastView(configuration: configuration)
            musicToastView.imageView.image = UIImage(named: "MUNA")
            musicToastView.titleLabel.text = "Silk Chiffon"
            musicToastView.subtitleLabel.text = "MUNA, Phoebe Bridgers"
            musicToastView.progressView.progress = 0.25
            return musicToastView
            
        }
        
    }

}


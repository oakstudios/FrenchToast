//
//  MusicToast.swift
//  FrenchToast_Example
//
//  Created by Alex Givens on 2/10/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import FrenchToast

class MusicToastView: ToastView {
            
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.7)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let playPauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressViewStyle = .bar
        progressView.trackTintColor = .white.withAlphaComponent(0.3)
        progressView.progressTintColor = .white
        progressView.layer.masksToBounds = true
        progressView.layer.cornerRadius = 2
        return progressView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    func customInit() {
        
        self.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        self.layer.cornerRadius = 6
        self.backgroundColor = .darkGray
        
        // Image View
        addSubview(imageView)
        topAnchor.constraint(equalTo: imageView.topAnchor, constant: -8).isActive = true
        leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -8).isActive = true
        bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        // Play Pause Button
        addSubview(playPauseButton)
        topAnchor.constraint(equalTo: playPauseButton.topAnchor, constant: -8).isActive = true
        trailingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 8).isActive = true
        bottomAnchor.constraint(equalTo: playPauseButton.bottomAnchor, constant: 8).isActive = true
        playPauseButton.heightAnchor.constraint(equalTo: playPauseButton.widthAnchor).isActive = true
        
        // Title label
        addSubview(titleLabel)
        imageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -10).isActive = true
        playPauseButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10).isActive = true
        centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: 8).isActive = true
        
        // Subtitle label
        addSubview(subtitleLabel)
        imageView.trailingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor, constant: -10).isActive = true
        playPauseButton.leadingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor, constant: 10).isActive = true
        centerYAnchor.constraint(equalTo: subtitleLabel.centerYAnchor, constant: -8).isActive = true
        
        // Progress View
        addSubview(progressView)
        leadingAnchor.constraint(equalTo: progressView.leadingAnchor, constant: -8).isActive = true
        trailingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 8).isActive = true
        bottomAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 1).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
    }
    
}

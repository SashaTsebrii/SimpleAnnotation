//
//  StickerImageView.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 8/19/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class StickerImageView: UIImageView {
    
    // MARK: - Variables
    
    var isEditing: Bool = false
    private let closeButtonWidth: CGFloat = 16

    // MARK: - Initialization
    
    override init(image: UIImage?) {
        super.init(image: image)
        
        initialization(withFrame: frame)
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialization(withFrame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    // MARK: - Helper
    
    private func initialization(withFrame frame: CGRect) {
        
        clipsToBounds = false
        backgroundColor = .clear
        contentMode = .scaleAspectFit
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
        
        let closeButtonRect = CGRect(x: 0, y: 0, width: closeButtonWidth, height: closeButtonWidth)
        let closeButton = UIButton(frame: closeButtonRect)
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        closeButton.tintColor = .white
        closeButton.layer.borderColor = UIColor.black.withAlphaComponent(0.7).cgColor
        closeButton.layer.borderWidth = 2
        closeButton.layer.cornerRadius = closeButtonWidth / 2
        closeButton.layer.masksToBounds = true
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_ :)), for: .touchUpInside)
        
        addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: closeButtonWidth),
            closeButton.heightAnchor.constraint(equalToConstant: closeButtonWidth),
            closeButton.topAnchor.constraint(equalTo: topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
    }
    
    // MARK: - Selectors
    
    @objc fileprivate func closeButtonTapped(_ sender: UIButton) {
        print("👆 CLOSE BUTTON")
        
        removeFromSuperview()
        
    }

}

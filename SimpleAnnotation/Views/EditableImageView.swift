//
//  EditableImageView.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 9/22/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class EditableImageView: UIImageView {
    
    // MARK: Variable
    
    var isEditing: Bool = true {
        didSet {
            if isEditing {
                closeButton.isHidden = false
            } else {
                closeButton.isHidden = true
            }
        }
    }
    
    private let closeButtonWidth: CGFloat = 16
    
    // MARK: Properties
    
    lazy var closeButton: UIButton = {
        let buttonRect = CGRect(x: 0, y: 0, width: closeButtonWidth, height: closeButtonWidth)
        let button = UIButton(frame: buttonRect)
        button.setImage(UIImage(named: "none_w"), for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        button.tintColor = .white
        button.layer.borderColor = UIColor.black.withAlphaComponent(0.7).cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = closeButtonWidth / 2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(closeButtonTapped(_ :)), for: .touchUpInside)
        return button
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = false
        backgroundColor = .clear
        contentMode = .scaleAspectFit
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: closeButtonWidth),
            closeButton.heightAnchor.constraint(equalToConstant: closeButtonWidth),
            closeButton.topAnchor.constraint(equalTo: topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        longPressGesture.minimumPressDuration = 1
        addGestureRecognizer(longPressGesture)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Selectors
    
    @objc fileprivate func closeButtonTapped(_ sender: UIButton) {
        print("👆 CLOSE BUTTON")
        
        removeFromSuperview()
        
    }
    
    @objc fileprivate func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            print("👋 LONG PRESS GESTURE")
            
            isEditing = !isEditing
            
        }
        
    }
    
}

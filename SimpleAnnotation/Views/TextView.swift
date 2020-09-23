//
//  TextView.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 9/23/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class TextView: UITextView {
        
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGesture)
        
        let rotationGesture = UITapGestureRecognizer()
        rotationGesture.addTarget(self, action: #selector(handleRotationGesture(_:)))
        addGestureRecognizer(rotationGesture)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func handleRotationGesture(_ gesture: UIRotationGestureRecognizer) {
        print("👋 ROTATION GESTURE IN NOTE IMAGE VIEW")

        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.transform = gestureView.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0

    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        print("👋 PAN GESTURE IN NOTE IMAGE VIEW")
        
        let translation = gesture.translation(in: superview)
        
        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.center = CGPoint(x: gestureView.center.x + translation.x, y: gestureView.center.y + translation.y)
        gesture.setTranslation(.zero, in: superview)
        
    }
    
}

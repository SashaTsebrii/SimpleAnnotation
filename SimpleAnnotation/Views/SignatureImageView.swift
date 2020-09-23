//
//  SignatureImageView.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 9/23/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class SignatureImageView: EditableImageView {
    
    // TODO: Rename SignatureImageView to SignatureView.

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(handlePanGesture(_:)))
        
        let pinchGesture = UIPinchGestureRecognizer()
        pinchGesture.addTarget(self, action: #selector(handlePinchGesture(_:)))
        
        let rotationGesture = UIRotationGestureRecognizer()
        rotationGesture.addTarget(self, action: #selector(handleRotateGesture(_:)))
        
        addGestureRecognizer(panGesture)
        addGestureRecognizer(pinchGesture)
        addGestureRecognizer(rotationGesture)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        print("👋 PAN GESTURE IN SIGNATURE IMAGE VIEW")
        
        let translation = gesture.translation(in: superview)
        
        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.center = CGPoint(x: gestureView.center.x + translation.x, y: gestureView.center.y + translation.y)
        gesture.setTranslation(.zero, in: superview)
        
    }
    
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        print("👋 PINCH GESTURE IN SIGNATURE IMAGE VIEW")
        
        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.transform = gestureView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1
        
    }
    
    @objc func handleRotateGesture(_ gesture: UIRotationGestureRecognizer) {
        print("👋 ROTATE GESTURE IN SIGNATURE IMAGE VIEW")
        
        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.transform = gestureView.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
        
    }

}

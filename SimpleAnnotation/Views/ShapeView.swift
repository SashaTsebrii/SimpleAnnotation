//
//  ShapeeView.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 9/23/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

enum Shapes {
    case line
    case arrow
    case size
    case rectangle
    case circle
    case check
    case cross
}

class ShapeeView: EditableView {
    
    var shapeType: Shapes

    init(shape: Shapes, frame: CGRect) {
        
        shapeType = shape
        
        super.init(frame: frame)
        
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
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
    
    override func draw(_ rect: CGRect) {
        
        switch shapeType {
            case .line:
                let arrow = UIBezierPath()
                arrow.addArrow(start: CGPoint(x: rect.minX, y: rect.midY), end: CGPoint(x: rect.maxX, y: rect.midY), pointerLineLength: 0, arrowAngle: CGFloat(Double.pi / 4))
                
                let arrowLayer = CAShapeLayer()
                arrowLayer.strokeColor = UIColor.black.cgColor
                arrowLayer.lineWidth = 3
                arrowLayer.path = arrow.cgPath
                arrowLayer.fillColor = UIColor.clear.cgColor
                arrowLayer.lineJoin = CAShapeLayerLineJoin.round
                arrowLayer.lineCap = CAShapeLayerLineCap.round
                
                layer.addSublayer(arrowLayer)
            case .arrow:
                let arrow = UIBezierPath()
                arrow.addArrow(start: CGPoint(x: rect.minX, y: rect.midY), end: CGPoint(x: rect.maxX, y: rect.midY), pointerLineLength: 30, arrowAngle: CGFloat(Double.pi / 4))
                
                let arrowLayer = CAShapeLayer()
                arrowLayer.strokeColor = UIColor.black.cgColor
                arrowLayer.lineWidth = 3
                arrowLayer.path = arrow.cgPath
                arrowLayer.fillColor = UIColor.clear.cgColor
                arrowLayer.lineJoin = CAShapeLayerLineJoin.round
                arrowLayer.lineCap = CAShapeLayerLineCap.round
                
                layer.addSublayer(arrowLayer)
            case .size:
                return
            case .rectangle:
                return
            case .circle:
                return
            case .check:
                return
            case .cross:
                return
        }
        
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        print("👋 PAN GESTURE IN SHAPE VIEW")
        
        let translation = gesture.translation(in: superview)
        
        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.center = CGPoint(x: gestureView.center.x + translation.x, y: gestureView.center.y + translation.y)
        gesture.setTranslation(.zero, in: superview)
        
    }
    
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        print("👋 PINCH GESTURE IN SHAPE VIEW")
        
        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.transform = gestureView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1
        
    }
    
    @objc func handleRotateGesture(_ gesture: UIRotationGestureRecognizer) {
        print("👋 ROTATE GESTURE IN SHAPE VIEW")
        
        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.transform = gestureView.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
        
    }

}

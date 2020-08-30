//
//  TestCanvasView.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 7/6/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class TestCanvasView: UIView {
    
    var bezierPath = UIBezierPath()
    var prevPoint: CGPoint?
    var isFirst = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isMultipleTouchEnabled = false
        backgroundColor = .clear
        bezierPath.lineWidth = 2.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        bezierPath.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        bezierPath.removeAllPoints()
        bezierPath.move(to: location)
        prevPoint = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        
        if let prevPoint = prevPoint {
            let midPoint = CGPoint(x: (location.x + prevPoint.x) / 2,
                                   y: (location.y + prevPoint.y) / 2)
            if isFirst {
                bezierPath.addLine(to: midPoint)
            } else {
                bezierPath.addQuadCurve(to: midPoint, controlPoint: prevPoint)
            }
            isFirst = false
        }
        prevPoint = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        bezierPath.addLine(to: location)
    }
    
}

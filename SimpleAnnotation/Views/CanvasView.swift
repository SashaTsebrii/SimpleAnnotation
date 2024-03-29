//
//  CanvasView.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 6/29/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class CanvasView: UIView {
    
    // MARK: Variables
    
    var context: CGContext?
    
    fileprivate var lines = [Line]()
    fileprivate var strokeColor = UIColor.black
    fileprivate var strokeWidth: Float = 1
    fileprivate var alphaValue: Float = 1
    
    // MARK: Public function
    
    func setAlphaValue(opacity: Float) {
        alphaValue = opacity
    }
    
    func setStrokeWidth(width: Float) {
        strokeWidth = width
    }
    
    func setStrokeColor(color: UIColor) {
        strokeColor = color
    }
    
    func undo() {
        _ = lines.popLast()
        setNeedsDisplay()
    }
    
    func clear() {
        lines.removeAll()
        setNeedsDisplay()
    }
    
    // MARK: Draw
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let context = UIGraphicsGetCurrentContext() {
            lines.forEach { (line) in
                context.setStrokeColor(line.color.cgColor)
                context.setLineWidth(CGFloat(line.strokeWidth))
                context.setAlpha(CGFloat(line.alpha))
                context.setLineCap(.round)
                for (i, p) in line.points.enumerated() {
                    if i == 0 {
                        context.move(to: p)
                    } else {
                        context.addLine(to: p)
                    }
                }
                context.strokePath()
            }
        }
        
    }
    
    // MARK: Responder
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        lines.append(Line.init(strokeWidth: strokeWidth, color: strokeColor, alpha: alphaValue, points: []))
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let point = touches.first?.location(in: self) else { return }
        guard var lastLine = lines.popLast() else { return }
        lastLine.points.append(point)
        lines.append(lastLine)
        setNeedsDisplay()
        
    }
    
}

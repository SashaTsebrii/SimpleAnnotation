//
//  SimpleCanvasView.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 7/6/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

/*
 @implementation LinearInterpView
 {
 UIBezierPath *path;
 }
 
 - (id)initWithCoder:(NSCoder *)aDecoder
 {
 if (self = [super initWithCoder:aDecoder])
 {
 [self setMultipleTouchEnabled:NO];
 [self setBackgroundColor:[UIColor whiteColor]];
 path = [UIBezierPath bezierPath];
 [path setLineWidth:2.0];
 }
 return self;
 }
 
 - (void)drawRect:(CGRect)rect
 {
 [[UIColor blackColor] setStroke];
 [path stroke];
 }
 
 - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
 {
 UITouch *touch = [touches anyObject];
 CGPoint p = [touch locationInView:self];
 [path moveToPoint:p];
 }
 
 - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
 {
 UITouch *touch = [touches anyObject];
 CGPoint p = [touch locationInView:self];
 [path addLineToPoint:p];
 [self setNeedsDisplay];
 }
 
 - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
 {
 [self touchesMoved:touches withEvent:event];
 }
 
 - (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
 {
 [self touchesEnded:touches withEvent:event];
 }
 @end
 */

class SimpleCanvasView: UIView {
    
    let path = UIBezierPath()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = false
        backgroundColor = .clear
        path.lineWidth = 2.0
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.black.setStroke()
        path.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self)
            path.move(to: point)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self)
            path.addLine(to: point)
            setNeedsDisplay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesMoved(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesMoved(touches, with: event)
    }
    
}

//
//  CachedCanvasView.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 7/6/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

/*
@implementation CachedLIView
{
    UIBezierPath *path;
    UIImage *incrementalImage; // (1)
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
    [incrementalImage drawInRect:rect]; // (3)
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
 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event // (2)
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [path addLineToPoint:p];
    [self drawBitmap]; // (3)
    [self setNeedsDisplay];
    [path removeAllPoints]; //(4)
}
 
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}
 
- (void)drawBitmap // (3)
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    [[UIColor blackColor] setStroke];
    if (!incrementalImage) // first draw; paint background white by ...
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds]; // enclosing bitmap by a rectangle defined by another UIBezierPath object
        [[UIColor whiteColor] setFill];
        [rectpath fill]; // filling it with white
    }
    [incrementalImage drawAtPoint:CGPointZero];
    [path stroke];
    incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
@end
*/

class CachedCanvasView: UIView {
    
    let path = UIBezierPath()
    var incrementalImage: UIImage!
    var isFirstTime = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isMultipleTouchEnabled = false
        backgroundColor = .clear
        path.lineWidth = 2.0
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        incrementalImage.draw(in: rect)
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
        if let touch = touches.first {
            let point = touch.location(in: self)
            path.addLine(to: point)
            drawBitmap()
            setNeedsDisplay()
            path.removeAllPoints()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    fileprivate func drawBitmap() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        UIColor.black.setStroke()
        if isFirstTime == true {
            isFirstTime = false
            let rectpath = UIBezierPath(rect: bounds)
            UIColor.clear.setFill()
            rectpath.fill()
        }
        incrementalImage.draw(at: .zero)
        path.stroke()
        incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

}

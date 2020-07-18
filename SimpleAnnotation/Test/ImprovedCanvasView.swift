//
//  ImprovedCanvasView.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 7/6/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

/*
@implementation BezierInterpView
{
    UIBezierPath *path;
    UIImage *incrementalImage;
    CGPoint pts[4]; // to keep track of the four points of our Bezier segment
    uint ctr; // a counter variable to keep track of the point index
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
    [incrementalImage drawInRect:rect];
    [path stroke];
}
 
 
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    ctr = 0;
    UITouch *touch = [touches anyObject];
    pts[0] = [touch locationInView:self];
}
 
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    ctr++;
    pts[ctr] = p;
    if (ctr == 3) // 4th point
    {
        [path moveToPoint:pts[0]];
        [path addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]]; // this is how a Bezier curve is appended to a path. We are adding a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
        [self setNeedsDisplay];
        pts[0] = [path currentPoint];
        ctr = 0;
    }
}
 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
     
    [self drawBitmap];
    [self setNeedsDisplay];
    pts[0] = [path currentPoint]; // let the second endpoint of the current Bezier segment be the first one for the next Bezier segment
    [path removeAllPoints];
    ctr = 0;
     
}
 
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}
 
- (void)drawBitmap
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    [[UIColor blackColor] setStroke];
    if (!incrementalImage) // first time; paint background white
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor whiteColor] setFill];
        [rectpath fill];
    }
    [incrementalImage drawAtPoint:CGPointZero];
    [path stroke];
    incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
@end
*/

class ImprovedCanvasView: UIView {
    
    let path = UIBezierPath()
    var incrementalImage: UIImage!
    var isFirstTime = true
    
    var points: [CGPoint] = [] // to keep track of the four points of our Bezier segment
    var counter: Int = 0 // a counter variable to keep track of the point index
    
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
        counter = 0
        if let touch = touches.first {
            points[0] = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self)
            counter = counter + 1
            points[counter] = point
            if counter == 3 {
                path.move(to: points[0])
                path.addCurve(to: points[3], controlPoint1: points[1], controlPoint2: points[2]) // this is how a Bezier curve is appended to a path. We are adding a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
                setNeedsDisplay()
                points[0] = path.currentPoint
                counter = 0
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        drawBitmap()
        setNeedsDisplay()
        points[0] = path.currentPoint // let the second endpoint of the current Bezier segment be the first one for the next Bezier segment
        path.removeAllPoints()
        counter = 0
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

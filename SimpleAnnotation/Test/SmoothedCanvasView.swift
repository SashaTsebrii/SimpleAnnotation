//
//  SmoothedCanvasView.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 7/6/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

/*
 @implementation SmoothedBIView
 {
 UIBezierPath *path;
 UIImage *incrementalImage;
 CGPoint pts[5]; // we now need to keep track of the four points of a Bezier segment and the first control point of the next segment
 uint ctr;
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
 - (id)initWithFrame:(CGRect)frame
 {
 self = [super initWithFrame:frame];
 if (self) {
 [self setMultipleTouchEnabled:NO];
 path = [UIBezierPath bezierPath];
 [path setLineWidth:2.0];
 }
 return self;
 }
 
 
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
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
 if (ctr == 4)
 {
 pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0); // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
 
 [path moveToPoint:pts[0]];
 [path addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]]; // add a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
 
 [self setNeedsDisplay];
 // replace points and get ready to handle the next segment
 pts[0] = pts[3];
 pts[1] = pts[4];
 ctr = 1;
 }
 
 }
 
 - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
 {
 [self drawBitmap];
 [self setNeedsDisplay];
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
 
 if (!incrementalImage) // first time; paint background white
 {
 UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
 [[UIColor whiteColor] setFill];
 [rectpath fill];
 }
 [incrementalImage drawAtPoint:CGPointZero];
 [[UIColor blackColor] setStroke];
 [path stroke];
 incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 }
 
 @end
 */

class SmoothedCanvasView: UIView {
    
    let path = UIBezierPath()
    var incrementalImage: UIImage!
    var isFirstTime = true
    
    var points: [CGPoint] = [] // we now need to keep track of the four points of a Bezier segment and the first control point of the next segment
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
            if counter == 4 {
                points[3] = CGPoint(x: (points[2].x + points[4].x) / 2.0, y: (points[2].y + points[4].y) / 2.0) // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
                
                path.move(to: points[0])
                path.addCurve(to: points[3], controlPoint1: points[1], controlPoint2: points[2]) // add a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
                
                setNeedsDisplay()
                
                // replace points and get ready to handle the next segment
                points[0] = points[3]
                points[1] = points[4]
                counter = 1
                
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

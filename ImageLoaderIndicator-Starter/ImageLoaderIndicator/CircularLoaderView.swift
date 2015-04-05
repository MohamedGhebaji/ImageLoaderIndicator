//
//  CircularLoaderView.swift
//  ImageLoaderIndicator
//
//  Created by Mohamed on 28/02/2015.
//  Copyright (c) 2015 Rounak Jain. All rights reserved.
//

import UIKit

let circlePathLayer = CAShapeLayer()
let circleRadius: CGFloat = 20.0

@IBDesignable
class CircularLoaderView: UIView {

    var progress: CGFloat {
        get {
            return circlePathLayer.strokeEnd
        }
        
        set {
            if newValue > 1 {
                circlePathLayer.strokeEnd = 1
            } else if newValue < 0 {
                circlePathLayer.strokeEnd = 0
            } else {
                circlePathLayer.strokeEnd = newValue
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circlePathLayer.frame = bounds;
        circlePathLayer.path = circlePath().CGPath
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        circlePathLayer.frame = bounds
        circlePathLayer.lineWidth = 2
        circlePathLayer.fillColor = UIColor.clearColor().CGColor
        circlePathLayer.strokeColor = UIColor.redColor().CGColor
        layer.addSublayer(circlePathLayer)
        backgroundColor = UIColor.whiteColor()
        progress = 0
    }
    
    func circleFrame() -> CGRect {
        var circleFrame = CGRectMake(0, 0, 2*circleRadius, 2*circleRadius)
        circleFrame.origin.x = CGRectGetMidX(circlePathLayer.bounds) - CGRectGetMidY(circleFrame)
        circleFrame.origin.y = CGRectGetMidY(circlePathLayer.bounds) - CGRectGetMidY(circleFrame)
        return circleFrame
    }

    func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalInRect: circleFrame())
    }
    
    func reveal() {
        backgroundColor = UIColor.clearColor()
        circlePathLayer.removeAnimationForKey("strokeEnd")
        circlePathLayer.removeFromSuperlayer()
        superview?.layer.mask = circlePathLayer
        
        let center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        let finalRadius = sqrt(center.x*center.x) + (center.y*center.y)
        let radiusInset = finalRadius - circleRadius
        let outerRect = CGRectInset(circleFrame(), -radiusInset, -radiusInset)
        let toPath = UIBezierPath(ovalInRect: outerRect).CGPath
        
        let fromPath = circlePathLayer.path
        let fromLineWidth = circlePathLayer.lineWidth
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        circlePathLayer.lineWidth = 2*finalRadius
        circlePathLayer.path = toPath
        CATransaction.commit()
        
        let lineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        lineWidthAnimation.fromValue = fromLineWidth
        lineWidthAnimation.toValue = 2*finalRadius
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = fromPath
        pathAnimation.toValue = toPath
        
        let groupeAnimation = CAAnimationGroup()
        groupeAnimation.duration = 1
        groupeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        groupeAnimation.animations = [pathAnimation, lineWidthAnimation]
        groupeAnimation.delegate = self
        circlePathLayer.addAnimation(groupeAnimation, forKey: "strokeWidth")
        
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        superview?.layer.mask = nil
    }
}

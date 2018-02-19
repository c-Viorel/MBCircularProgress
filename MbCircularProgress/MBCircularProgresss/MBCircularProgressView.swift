//
//  MBCircularProgressView.swift
//  MbCircularProgress
//
//  Created by Viorel Porumbescu on 19/02/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Cocoa

let pink = NSColor(calibratedRed: 1, green: 0.059, blue: 0.575, alpha: 1)
let blue = NSColor(calibratedRed: 20/255, green: 160/255, blue: 255, alpha: 1)
let green = NSColor(calibratedRed: 0.321, green: 0.95, blue: 0.2, alpha: 1)


@IBDesignable
class MBCircularProgressView: NSControl {
    
    @IBInspectable var startAngle:CGFloat        = -130 {didSet {self.resetLayesProperties()}}
    @IBInspectable var endAngle:CGFloat          = -50  {didSet {self.resetLayesProperties()}}
    @IBInspectable var radius:CGFloat            = 60   {didSet {self.resetLayesProperties()}}
    @IBInspectable var width:CGFloat             = 10   {didSet {self.resetLayesProperties()}}
    @IBInspectable var color:NSColor             = green   {didSet {self.resetLayesProperties()}}
    @IBInspectable var backgroundColor:NSColor   = green.withAlphaComponent(0.2) {didSet {self.resetLayesProperties()}}
    @IBInspectable var clockwise:Bool            = true {didSet {self.resetLayesProperties()}}
    @IBInspectable var animationDuration:CGFloat = 0.25
    @IBInspectable var glowOpacity:Float         = 0.4  {didSet {self.resetLayesProperties()}}
    @IBInspectable var glowRadius:CGFloat        = 8    {didSet {self.resetLayesProperties()}}

    
    // Accept/return values from 0.0 to 1.0
    open var progress:CGFloat {
        get {
           return barLayer.strokeEnd
        }
        set {
            barLayer.animateProgress(newValue, duration: animationDuration)
        }
    }
    
    // Accept/return values from 0.0 to 1.0
    override var floatValue: Float {
        get {
            return Float(barLayer.strokeEnd)
        }
        set {
            barLayer.animateProgress(CGFloat(newValue), duration: animationDuration)
        }
    }
    
    override var frame: NSRect {
        didSet{
            self.resetLayesProperties()
        }
    }
    
//    override func viewDidEndLiveResize() {
//        self.resetLayesProperties()
//    }
    //Print a sumar description about instance object.
    override var description: String {
        get {
            return """
            ------- MBCircularProgressView ---------
            startAnge:    \(self.startAngle)
            endAngle:     \(self.endAngle)
            radius:       \(self.radius)
            width:        \(self.width)
            clockwise:    \(self.clockwise)
            animDuration: \(self.animationDuration)
            glowOpacity:  \(self.glowOpacity)
            glowRadius:   \(self.glowRadius)
            ------------------------------------------
            """
        }
    }
    
    //private vars
    fileprivate var barLayer:CircularBarLayer      = CircularBarLayer(center: CGPoint.init(x: 50, y: 50) , radius: 10, width: 10, startAngle: 120, endAngle: 10, color: NSColor.red)
    fileprivate var backgroundBar:CircularBarLayer = CircularBarLayer(center: CGPoint.init(x: 50, y: 50) , radius: 10, width: 10, startAngle: 120, endAngle: 10, color: NSColor.red)
    
    
    //MARK:- Init
    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
        resetLayesProperties()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        resetLayesProperties()
    }
    
    
    override func prepareForInterfaceBuilder() {
        setup()
        resetLayesProperties()
    }
    
    //MARK:-Setup
    private func setup() {
        self.wantsLayer = true
        self.layer?.addSublayer(backgroundBar)
        self.layer?.addSublayer(barLayer)
    }
    
    private func resetLayesProperties() {
        let currentProgress = progress
        barLayer.removeFromSuperlayer()
        backgroundBar.removeFromSuperlayer()
        barLayer               = CircularBarLayer(center: CGPoint.init(x: self.bounds.midX, y: self.bounds.midY),
                                    radius: self.radius,
                                    width: self.width ,
                                    startAngle: self.startAngle,
                                    endAngle: self.endAngle,
                                    color: self.color,
                                    clockWise: self.clockwise)
        barLayer.progress      = currentProgress
        barLayer.shadowColor   = self.color.cgColor
        barLayer.shadowRadius  = self.glowRadius
        barLayer.shadowOpacity = self.glowOpacity
        barLayer.shadowOffset  = NSSize.zero
        backgroundBar          = CircularBarLayer(center: CGPoint.init(x: self.bounds.midX, y: self.bounds.midY),
                                         radius: self.radius,
                                         width: self.width ,
                                         startAngle: self.startAngle,
                                         endAngle: self.endAngle,
                                         color: self.backgroundColor,
                                         clockWise: self.clockwise)
        backgroundBar.progress      = 1.0
        backgroundBar.shadowColor   = self.backgroundColor.cgColor
        backgroundBar.shadowRadius  = self.glowRadius
        backgroundBar.shadowOpacity = self.glowOpacity
        backgroundBar.shadowOffset  = NSSize.zero
        
       
        self.layer?.addSublayer(backgroundBar)
        self.layer?.addSublayer(barLayer)
    }
    
    /// Animate progress with custom duration, and a completion bloc
    open func animateProgress(_ progress: CGFloat, duration: CGFloat, completion: (() -> Void)? = nil) {
        barLayer.animateProgress(progress, duration: duration, completion: completion)
    }
    
    
}


/// Extend layer capabilities to be able to create stroked arc lines.
fileprivate class CircularBarLayer: CAShapeLayer, CALayerDelegate, CAAnimationDelegate {
    
    var completion: (() -> Void)?
    
    open var progress: CGFloat? {
        get {
            return strokeEnd
        }
        set {
            strokeEnd = (newValue ?? 0)
        }
    }
    
    public init(center: CGPoint, radius: CGFloat, width: CGFloat, startAngle: CGFloat, endAngle: CGFloat, color: NSColor, clockWise:Bool = true) {
        super.init()
        let bezier  = NSBezierPath()
        bezier.appendArc(withCenter: NSZeroPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockWise)
        bezier.transform(using: AffineTransform(translationByX: center.x, byY: center.y))
        delegate    = self as CALayerDelegate
        path        = bezier.cgPath
        fillColor   = NSColor.clear.cgColor
        strokeColor = color.cgColor
        lineWidth   = width
        lineCap     = kCALineCapRound
        strokeStart = 0
        strokeEnd   = 0
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    open func animateProgress(_ progress: CGFloat, duration: CGFloat, completion: (() -> Void)? = nil) {
        removeAllAnimations()
        let progress             = progress
        let animation            = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue      = strokeEnd
        animation.toValue        = progress
        animation.duration       = CFTimeInterval(duration)
        animation.delegate       = self as CAAnimationDelegate
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        strokeEnd                = progress
        add(animation, forKey: "strokeEnd")
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            completion?()
        }
    }
}


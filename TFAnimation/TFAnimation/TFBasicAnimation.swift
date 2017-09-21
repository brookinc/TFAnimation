//
//  TFAnimation.swift
//  UIViewAnimation
//
//  Created by Luo on 6/3/16.
//  Copyright © 2016 Luo. All rights reserved.
//

import UIKit

typealias TFBasicAnimationFunction = (CGFloat) -> CGFloat

class TFBasicAnimation : CAKeyframeAnimation {

    var timeFunction: TFBasicAnimationFunction? {
        didSet {
            self.setValues()
        }
    }
    
    var fromValue: Any? {
        didSet {
            self.setValues()
        }
    }
    var toValue: Any? {
        didSet {
            self.setValues()
        }
    }
    var byValue: Any? {
        didSet {
            self.setValues()
        }
    }
    
    
    fileprivate var valuePairs : (CGFloat,CGFloat)? {
        get {
            if let from = fromValue as? CGFloat,let to = toValue as? CGFloat {
                return (from,to)
            } else if let from = fromValue as? CGFloat,let by = byValue as? CGFloat{
                return (from,from + by)
            } else if let to = toValue as? CGFloat,let by = byValue as? CGFloat{
                return (to - by,to)
            }
            return nil
        }
    }
    
    fileprivate func setValues() {
        let fps = 60
        let steps = Int((CGFloat(fps) * CGFloat(self.duration)))
        let timeStep = 1.0 / CGFloat(steps)
        var values = [CGFloat]()
        var keyTimes = [NSNumber]()
        var time:CGFloat = 0
        if let (from,to) = self.valuePairs {
            if let timeFunction = self.timeFunction {
                for _ in 0..<steps{
                    let value = from + to * timeFunction(time)
                    values.append(value)
                    keyTimes.append(NSNumber(value: Double(time)))
                    time += timeStep
                    
                }
                self.values = values
                self.keyTimes = keyTimes
            }
        }
    }
}




//
//  TFAnimation.swift
//  UIViewAnimation
//
//  Created by Luo on 6/3/16.
//  Copyright © 2016 Luo. All rights reserved.
//

import UIKit

// You can bind TFFloat to Float, Double, or CGFloat according to your preferences
// (ie. whichever type you'll be passing in most commonly for your to/from/by values,
// to minimize the amount of explicit type conversion you'll have to do)
typealias TFFloat = CGFloat

typealias TFBasicAnimationFunction = (TFFloat) -> TFFloat

class TFBasicAnimation: CAKeyframeAnimation {

    var timeFunction: TFBasicAnimationFunction? {
        didSet {
            self.setValues()
        }
    }
    
    var fromValue: TFFloat? {
        didSet {
            self.setValues()
        }
    }

    var toValue: TFFloat? {
        didSet {
            self.setValues()
        }
    }

    var byValue: TFFloat? {
        didSet {
            self.setValues()
        }
    }
    
    private var valuePairs: (TFFloat, TFFloat)? {
        if let from = fromValue, let to = toValue {
            return (from, to)
        } else if let from = fromValue, let by = byValue {
            return (from, from + by)
        } else if let to = toValue, let by = byValue {
            return (to - by, to)
        }
        return nil
    }
    
    private func setValues() {
        let fps = 60
        let steps = Int((TFFloat(fps) * TFFloat(self.duration)))
        let timeStep = 1.0 / TFFloat(steps)
        var values = [TFFloat]()
        var keyTimes = [NSNumber]()
        var time: TFFloat = 0
        if let (from, to) = self.valuePairs {
            if let timeFunction = self.timeFunction {
                for _ in 0 ..< steps{
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

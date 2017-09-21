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

infix operator ^^: BitwiseShiftPrecedence  // see https://developer.apple.com/documentation/swift/operator_declarations
func ^^ (radix: TFFloat, power: TFFloat) -> TFFloat {
    return pow(TFFloat(radix), TFFloat(power))
}

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
                for _ in 0 ..< steps {
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

    typealias TFEasingFunction = TFBasicAnimationFunction

    static let linearEase: TFEasingFunction = {
        $0
    }

    static let quadEaseIn: TFEasingFunction = {
        $0 ^^ 2
    }

    static let quadEaseOut: TFEasingFunction = {
        $0 * (2 - $0)
    }

    static let quadEaseInOut: TFEasingFunction = {
        if $0 < 0.5 {
            return 2 * $0 * $0
        } else {
            return -1 + (4 - 2 * $0) * $0
        }
    }

    static let cubicEaseIn: TFEasingFunction = {
        $0 ^^ 3
    }

    static let cubicEaseOut: TFEasingFunction = {
        ($0 - 1) ^^ 3 + 1
    }

    static let cubicEaseInOut: TFEasingFunction = {
        if $0 < 0.5 {
            return 4 * ($0 ^^ 3)
        } else {
            return ($0 - 1) * ((2 * $0 - 2) ^^ 2) + 1
        }
    }

    static let quartEaseIn: TFEasingFunction = {
        $0 ^^ 4
    }

    static let quartEaseOut: TFEasingFunction = {
        1 - (($0 - 1) ^^ 4)
    }

    static let quartEaseInOut: TFEasingFunction = {
        if $0 < 0.5 {
            return 8 * ($0 ^^ 4)
        } else {
            return -1 / 2 * ((2 * $0 - 2) ^^ 4) + 1
        }
    }

    static let bounceEaseIn: TFEasingFunction = {
        return 1.0 - bounceEaseOut(1.0 - $0)
    }

    static let bounceEaseOut: TFEasingFunction = {
        if $0 < 4.0 / 11.0 {
            return pow(11.0 / 4.0, 2) * pow($0, 2)
        }
        if $0 < 8.0 / 11.0 {
            return 3.0 / 4.0 + pow(11.0 / 4.0, 2) * pow($0 - 6.0 / 11.0, 2)
        }
        if $0 < 10.0 / 11.0 {
            return 15.0 / 16.0 + pow(11.0 / 4.0, 2) * pow($0 - 9.0 / 11.0, 2)
        }
        return 63.0 / 64.0 + pow(11.0 / 4.0, 2) * pow($0 - 21.0 / 22.0, 2)
    }

    static let expoEaseIn: TFEasingFunction = {
        return $0 == 0 ? 0.0 : (2 ^^ (10 * ($0 - 1)))
    }

    static let expoEaseOut: TFEasingFunction = {
        return $0 == 1.0 ? 1 : 1 - ( 2 ^^ ( -10 * $0))
    }

    static let expoEaseInOut: TFEasingFunction = {
        if $0 == 0 {
            return 0.0
        }
        if $0 == 1 {
            return 1.0
        }
        if $0 < 0.5 {
            return (2 ^^ (10 * (2 * $0 - 1))) / 2
        } else {
            return 1 - (2 ^^ (-10 * (2 * $0 - 1))) / 2
        }
    }

    static func sinEase(period: TFFloat) -> TFEasingFunction {
        return {
            -1.0 * sin(2.0 * TFFloat.pi * period * TFFloat($0))
        }
    }
}

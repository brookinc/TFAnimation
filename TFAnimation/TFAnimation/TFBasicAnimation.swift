//
//  TFBasicAnimation.swift
//  https://github.com/luowenxing/TFAnimation/
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
            if valuePairs == nil {
                print("Error: at least TWO of [fromValue, toValue, byValue] must be set for TFBasicAnimation to animate.")
            }
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
        // Unlike CABasicAnimation (https://developer.apple.com/documentation/quartzcore/cabasicanimation),
        // we require that TWO of [fromValue, toValue, byValue] are set
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
        var time: TFFloat = 0.0
        if let (from, to) = self.valuePairs {
            if let timeFunction = self.timeFunction {
                for _ in 0 ..< steps {
                    let value = from + (to - from) * timeFunction(time)
                    values.append(value)
                    keyTimes.append(NSNumber(value: Double(time)))
                    time += timeStep
                }
                self.values = values
                self.keyTimes = keyTimes
            }
        }
    }

    static let linearEase: TFBasicAnimationFunction = {
        $0
    }

    static let quadEaseIn: TFBasicAnimationFunction = {
        $0 ^^ 2.0
    }

    static let quadEaseOut: TFBasicAnimationFunction = {
        $0 * (2.0 - $0)
    }

    static let quadEaseInOut: TFBasicAnimationFunction = {
        if $0 < 0.5 {
            return 2.0 * $0 * $0
        } else {
            return -1.0 + (4.0 - 2.0 * $0) * $0
        }
    }

    static let cubicEaseIn: TFBasicAnimationFunction = {
        $0 ^^ 3.0
    }

    static let cubicEaseOut: TFBasicAnimationFunction = {
        ($0 - 1.0) ^^ 3.0 + 1.0
    }

    static let cubicEaseInOut: TFBasicAnimationFunction = {
        if $0 < 0.5 {
            return 4.0 * ($0 ^^ 3.0)
        } else {
            return ($0 - 1.0) * ((2.0 * $0 - 2.0) ^^ 2.0) + 1.0
        }
    }

    static let quartEaseIn: TFBasicAnimationFunction = {
        $0 ^^ 4.0
    }

    static let quartEaseOut: TFBasicAnimationFunction = {
        1.0 - (($0 - 1.0) ^^ 4.0)
    }

    static let quartEaseInOut: TFBasicAnimationFunction = {
        if $0 < 0.5 {
            return 8.0 * ($0 ^^ 4.0)
        } else {
            return -1.0 / 2.0 * ((2.0 * $0 - 2.0) ^^ 4.0) + 1.0
        }
    }

    static let bounceEaseIn: TFBasicAnimationFunction = {
        return 1.0 - bounceEaseOut(1.0 - $0)
    }

    static let bounceEaseOut: TFBasicAnimationFunction = {
        if $0 < 4.0 / 11.0 {
            return pow(11.0 / 4.0, 2.0) * pow($0, 2.0)
        }
        if $0 < 8.0 / 11.0 {
            return 3.0 / 4.0 + pow(11.0 / 4.0, 2.0) * pow($0 - 6.0 / 11.0, 2.0)
        }
        if $0 < 10.0 / 11.0 {
            return 15.0 / 16.0 + pow(11.0 / 4.0, 2.0) * pow($0 - 9.0 / 11.0, 2.0)
        }
        return 63.0 / 64.0 + pow(11.0 / 4.0, 2.0) * pow($0 - 21.0 / 22.0, 2.0)
    }

    static let expoEaseIn: TFBasicAnimationFunction = {
        return $0 == 0.0 ? 0.0 : (2.0 ^^ (10.0 * ($0 - 1.0)))
    }

    static let expoEaseOut: TFBasicAnimationFunction = {
        return $0 == 1.0 ? 1.0 : 1.0 - (2.0 ^^ ( -10.0 * $0))
    }

    static let expoEaseInOut: TFBasicAnimationFunction = {
        if $0 == 0.0 {
            return 0.0
        }
        if $0 == 1.0 {
            return 1.0
        }
        if $0 < 0.5 {
            return (2.0 ^^ (10.0 * (2.0 * $0 - 1.0))) / 2.0
        } else {
            return 1.0 - (2.0 ^^ (-10.0 * (2.0 * $0 - 1.0))) / 2.0
        }
    }

    /// Returns a sine-wave easing function.
    ///
    /// - parameters:
    ///     - period: the number of full cycles to include (ie. frequency) (default is 1.0)
    ///     - phaseShift: the proportion of a full cycle to shift the phase by (default is 0.0)
    ///     - amplitude: multiplier for the amplitude (default is 1.0)
    ///     - yOffset: the vertical offset to apply (default is 0.0)
    static func sinEase(period: TFFloat = 1.0, phaseShift: TFFloat = 0.0, amplitude: TFFloat = 1.0, yOffset: TFFloat = 0.0) -> TFBasicAnimationFunction {
        return {
            sin(TFFloat($0) * TFFloat.pi * 2.0 * period - phaseShift * TFFloat.pi * 2.0) * amplitude + yOffset
        }
    }
    
    static let sinEaseIn = sinEase(period: 0.25, phaseShift: 0.25, yOffset: 1.0)
    static let sinEaseOut = sinEase(period: 0.25)
    static let sinEaseInOut = sinEase(period: 0.5, phaseShift: 0.25, amplitude: 0.5, yOffset: 0.5)
    
}

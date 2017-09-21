# TFAnimation
The `timingFunction` of `CAAnimation` only allows us to create a named or cubic-bezier `CAMediaTimingFunction`. `TFAnimation` is a light weight implementation which enhances `CABasicAnimation` with a custom `timeFunction` whose domain should be between 0 and 1, like cubic-bezier.

# Demo
![A simple sin curve like animation](https://github.com/luowenxing/TFAnimation/blob/master/TFAnimation/Demo/demo.gif?raw=true)

A simple sin-curve-like animation with timingFunction of f(t) = sin (4π * t)

# Usage
* Drag `TFBasicAnimation.swift` to your project
* Use it just as you would `CABasicAnimation`, but assign `timeFunction` a `(CGFloat) -> CGFloat` closure, rather than assigning `timingFunction`.
```
let animationY = TFBasicAnimation()
animationY.keyPath = "position.y"
animationY.fromValue = 0
animationY.byValue = height / 4
animationY.duration = 5.0
animationY.timeFunction = {
  t in
  return t * t
}
```
* Several standard pre-defined timing functions (`quadEaseInOut`, `cubicEaseInOut`, etc.) are included in the class.

# Reference & Inspiration
* [animations-explained](https://www.objc.io/issues/12-animations/animations-explained/)
* [RBBAnimation](https://github.com/robb/RBBAnimation)

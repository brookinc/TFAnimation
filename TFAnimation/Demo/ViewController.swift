//
//  ViewController.swift
//  https://github.com/luowenxing/TFAnimation/
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var rect: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animation()
    }
    @IBAction func btnReplay(_ sender: AnyObject) {
        self.animation()
    }
    
    var animationIndex = 0
    
    private func animation() {
        let width = self.view.frame.width - self.rect.frame.width
        let height = self.view.frame.height
        
        let animationX = CABasicAnimation()
        animationX.keyPath = "position.x"
        animationX.fromValue = 0.0
        animationX.toValue = width
        animationX.duration = 1.0
        animationX.isAdditive = true
        
        let animationY = TFBasicAnimation()
        animationY.keyPath = "position.y"
        animationY.fromValue = 0.0
        animationY.byValue = -(height / CGFloat(4.0))
        animationY.duration = 1.0
        animationY.isAdditive = true  // calculate our values relative to the object's (local) coordinates
        switch animationIndex % 19 {
        case 0:
            animationY.timeFunction = TFBasicAnimation.linearEase
        case 1:
            animationY.timeFunction = TFBasicAnimation.quadEaseIn
        case 2:
            animationY.timeFunction = TFBasicAnimation.quadEaseOut
        case 3:
            animationY.timeFunction = TFBasicAnimation.quadEaseInOut
        case 4:
            animationY.timeFunction = TFBasicAnimation.cubicEaseIn
        case 5:
            animationY.timeFunction = TFBasicAnimation.cubicEaseOut
        case 6:
            animationY.timeFunction = TFBasicAnimation.cubicEaseInOut
        case 7:
            animationY.timeFunction = TFBasicAnimation.quartEaseIn
        case 8:
            animationY.timeFunction = TFBasicAnimation.quartEaseOut
        case 9:
            animationY.timeFunction = TFBasicAnimation.quartEaseInOut
        case 10:
            animationY.timeFunction = TFBasicAnimation.bounceEaseIn
        case 11:
            animationY.timeFunction = TFBasicAnimation.bounceEaseOut
        case 12:
            animationY.timeFunction = TFBasicAnimation.expoEaseIn
        case 13:
            animationY.timeFunction = TFBasicAnimation.expoEaseOut
        case 14:
            animationY.timeFunction = TFBasicAnimation.expoEaseInOut
        case 15:
            animationY.timeFunction = TFBasicAnimation.sinEase(period: 2.0)
        case 16:
            animationY.timeFunction = TFBasicAnimation.sinEaseIn
        case 17:
            animationY.timeFunction = TFBasicAnimation.sinEaseOut
        case 18:
            animationY.timeFunction = TFBasicAnimation.sinEaseInOut
        default:
            print("Missing time function!")
        }
        animationIndex += 1
        
        let group = CAAnimationGroup()
        group.animations = [animationX, animationY]
        group.duration = 1.0
        group.beginTime = 0.0
        //group.autoreverses = true
        group.repeatCount = .infinity

        self.rect.layer.add(group, forKey: "TF")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

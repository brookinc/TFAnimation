//
//  ViewController.swift
//  UIViewAnimation
//
//  Created by Luo on 6/2/16.
//  Copyright © 2016 Luo. All rights reserved.
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
        animationX.fromValue = 0
        animationX.toValue = width
        animationX.duration = 5.0
        animationX.isAdditive = true
        
        let animationY = TFBasicAnimation()
        animationY.keyPath = "position.y"
        animationY.fromValue = 0
        animationY.byValue = -(height / CGFloat(4.0))
        animationY.duration = 5.0
        animationY.isAdditive = true
        switch animationIndex % 4 {
        case 0:
            animationY.timeFunction = TFBasicAnimation.sinEase(period: 2)
        case 1:
            animationY.timeFunction = TFBasicAnimation.sinEaseIn
        case 2:
            animationY.timeFunction = TFBasicAnimation.sinEaseOut
        default:
            animationY.timeFunction = TFBasicAnimation.sinEaseInOut
        }
        animationIndex += 1
        
        let group = CAAnimationGroup()
        group.animations = [animationX, animationY]
        group.duration = 5.0
        group.beginTime = 0.0
        
        self.rect.layer.add(group, forKey: "TF")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

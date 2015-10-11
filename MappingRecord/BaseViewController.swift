//
//  BaseViewController.swift
//  RunningMap
//
//  Created by Hiroki Nakajima on 2015/08/30.
//  Copyright (c) 2015年 Hiroki Nakajima. All rights reserved.
//

import UIKit
import Spring

class BaseViewController: UIViewController {
    
    var mappingStarted = false
    let mapImageName = "map.png"
    let historyImageName = "stopwatch.png"
    let mapTabString = "Map"
    let historyTabString = "History"
    
    func appendCenterButton() {
        let spButton: SpringButton = (SpringButton(type: UIButtonType.Custom))
        
        let image: UIImage? = UIImage(named:"pencil.png")
        
        spButton.setImage(image, forState: UIControlState.Normal)
        spButton.frame = CGRectMake(0, 0, 60, 70)
        spButton.addTarget(self, action: "onClickSpButton:", forControlEvents:.TouchUpInside)
        spButton.layer.position = CGPoint(x: self.view.frame.width / 2, y: UIScreen.mainScreen().bounds.size.height - spButton.frame.height + 40)
        spButton.layer.borderWidth = 0
 
        self.tabBarController?.view.addSubview(spButton)
    }

}

extension UIImage {
    func tint(color: UIColor, blendMode: CGBlendMode) -> UIImage {
        let drawRect = CGRectMake(0.0, 0.0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        //let context = UIGraphicsGetCurrentContext()
        //CGContextClipToMask(context, drawRect, CGImage)
        color.setFill()
        UIRectFill(drawRect)
        drawInRect(drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        tintedImage.imageWithRenderingMode(.AlwaysOriginal)
        return tintedImage
    }
}

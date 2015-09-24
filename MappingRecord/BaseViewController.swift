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

//    @IBAction func onClickSpButton(sender: SpringButton) {
//        // SpringButtonにアニメーションを設定し実行後、マッピング開始フラグをオンorオフする。
//        sender.animation = "pop"
//        sender.animate()
//        //AppDelegateのインスタンスを取得
//        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        //        if self.mappingStarted {
////            mappingStarted = false
////        } else {
////            mappingStarted = true
////        }
//    }
    
}

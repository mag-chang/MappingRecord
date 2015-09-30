//
//  CustomTabBarController.swift
//  MappingRecord
//
//  Created by Hiroki Nakajima on 2015/09/13.
//  Copyright (c) 2015年 Hiroki Nakajima. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate  {
    
    // Tabに設定するViewControllerのインスタンスを生成.
    let gmapViewTab: UIViewController = GMapViewController()
    let historyTab: UIViewController = HistoryViewController()

    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.delegate = self

        // タブを要素に持つArrayを作成する.
        let myTabs = NSArray(objects: gmapViewTab,historyTab)
        
        // ViewControllerを設定する.
        self.setViewControllers(myTabs as? [UIViewController], animated: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UITabBarControllerDelegateプロトコルを実装する
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        historyTab.viewDidLoad()
        return true
    };
    //UITabBarControllerDelegateプロトコルを実装する
//    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
//        print("didSelectViewController")
//    }
    
}
//
//  HistoryViewController.swift
//  RunningMap
//
//  Created by Hiroki Nakajima on 2015/08/29.
//  Copyright (c) 2015年 Hiroki Nakajima. All rights reserved.
//

//import Foundation
import UIKit

class HistoryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource  {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        // Viewの背景色をGreenに設定する.
        self.view.backgroundColor = UIColor.greenColor()
        
        // tabBarItemのアイコンをFeaturedに、タグを2と定義する.
        self.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Featured, tag: 2)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    //テーブルビューインスタンス作成
    var tableView: UITableView  =   UITableView()
    
    //テーブルに表示するセル配列
    var items: [String] = ["走行履歴１", "走行履歴２", "走行履歴３","走行履歴４","走行履歴５"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        super.appendCenterButton()
        
        //テーブルビュー初期化、関連付け
        tableView.frame         =   CGRectMake(0, 0, 600, 240);
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("セルを選択しました！ #\(indexPath.row)!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


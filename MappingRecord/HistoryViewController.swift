//
//  HistoryViewController.swift
//  RunningMap
//
//  Created by Hiroki Nakajima on 2015/08/29.
//  Copyright (c) 2015年 Hiroki Nakajima. All rights reserved.
//

//import Foundation
import UIKit
import Spring
import RealmSwift

class HistoryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        // tabBarItemのアイコンを設定、タグを2と定義する.
//        self.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.History, tag: 2)
        let historyImageSelected: UIImage? = UIImage(named: historyImageName)?.imageWithRenderingMode(.AlwaysOriginal)
        let historyImage: UIImage? = UIImage(named: historyImageName)?.imageWithRenderingMode(.AlwaysOriginal).tint(UIColor.grayColor(),
            blendMode: .DestinationIn)
        self.tabBarItem = UITabBarItem(title: historyTabString, image: historyImage, selectedImage: historyImageSelected)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    required override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    //テーブルビューインスタンス作成
    var tableView: UITableView  =   UITableView()
    
    //テーブルに表示するセル配列
//    var items: Dictionary<Int,String> = [:]
    var items: Array<String> = []
    var seqNos: Array<Int> = []
    
    let dateFormatter = NSDateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        items.removeAll()
        seqNos.removeAll()
        self.setItemsValue(self.getRecords())
        
        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        
        // Viewの高さと幅を取得する.
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // TableViewの生成する(status barの高さ分ずらして表示).
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        
        // Cell名の登録をおこなう.
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        // DataSourceの設定をする.
        tableView.dataSource = self
        
        // Delegateを設定する.
        tableView.delegate = self
        
        // Viewに追加する.
        self.view.addSubview(tableView)

        // ステータスバー部分を白に置き換え。
        let statusBarArea = UIView(frame: CGRect(x:0, y:0, width: displayWidth, height: barHeight))
        statusBarArea.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(statusBarArea)
    }
    
    func getRecords() -> Results<Record> {
        let records = try! Realm().objects(Record).sorted("startDate")
        return records
    }
    
    func setItemsValue(records: Results<Record>) {
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") // ロケールの設定
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .ShortStyle
        for record in records {
            items.append("日時:\(dateFormatter.stringFromDate(record.startDate)) \n移動距離:\(record.distance.description)")
            seqNos.append(record.seqNo)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    Cellが選択された際に呼び出されるデリゲートメソッド.
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 表示するviewをmapviewに戻す
        self.tabBarController?.selectedIndex = 0

        // テーブルセルのtagを取得し、gMapViewControllerへ渡す（tagがDBのユニークキー）
        let seqNo = self.tableView.cellForRowAtIndexPath(indexPath)?.tag
        let gMapViewContoroller = self.tabBarController?.selectedViewController as! GMapViewController
        gMapViewContoroller.onClickTableCell(seqNo!)
    }
    
    /*
    Cellの総数を返すデータソースメソッド.
    (実装必須)
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    /*
    Cellに値を設定するデータソースメソッド.
    (実装必須)
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) 
        cell.textLabel?.numberOfLines = 2
        // Cellに値を設定する.
        cell.textLabel?.text = "\(items[indexPath.row])"
        cell.tag = seqNos[indexPath.row]
        
        return cell
    }
 
}


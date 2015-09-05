//
//  Record.swift
//  MappingRecord
//
//  Created by Hiroki Nakajima on 2015/09/05.
//  Copyright (c) 2015年 Hiroki Nakajima. All rights reserved.
//

import RealmSwift

/**
計測したデータをRealmに保存するためのオブジェクト
+ distance:    総距離
+ average:     平均速度
+ createdDate: 作成日時
*/
class Record: Object {
    
    dynamic var distance = Double()
    //    dynamic var polyLine: AnyObject = ""
    dynamic var average = Double()
    dynamic var createdDate = Double()
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}


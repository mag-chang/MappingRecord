//
//  Record.swift
//  MappingRecord
//
//  Created by Hiroki Nakajima on 2015/09/05.
//  Copyright (c) 2015年 Hiroki Nakajima. All rights reserved.
//

import RealmSwift
import GoogleMaps

/**
計測したデータをRealmに保存するためのオブジェクト
+ distance:    総距離
+ polyLine:    地図の軌跡(LatitudeとLongitudeの集合)
+ average:     平均速度
+ createdDate: 作成日時
*/
class Record: Object {
    
    dynamic var seqNo: Int = 0
    dynamic var startDate: NSDate = NSDate()
    dynamic var endDate: NSDate = NSDate()
    dynamic var distance: Double = 0
    dynamic var polyLine = List<PolylineArray>()
    dynamic var average: Double = 0
    dynamic var createdDate: Double = 0
    dynamic var updatedDate: Double = 0
    // Specify properties to ignore (Realm won't persist these)

    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}

class PolylineArray: Object {
    dynamic var poliLineLatitude: Double = 0
    dynamic var poliLineLongitude: Double = 0
}



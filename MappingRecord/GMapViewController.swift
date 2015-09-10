//
//  GMapViewController.swift
//  RunningMap
//
//  Created by Hiroki Nakajima on 2015/08/01.
//  Copyright (c) 2015年 Hiroki Nakajima. All rights reserved.
//

import UIKit
import GoogleMaps
import Spring
import RealmSwift

class GMapViewController: BaseViewController, CLLocationManagerDelegate {
    // TODO クラスをそれぞれ分割する。
    var lm: CLLocationManager
    var longitude: CLLocationDegrees   // 経度
    var latitude: CLLocationDegrees    // 緯度
    var mapView: GMSMapView
    var camera: GMSCameraPosition
    var marker = GMSMarker()
    
    var targetPath = GMSMutablePath()
    var poliLine = GMSPolyline()
    
    var fromLocation = CLLocationCoordinate2D()
    var toLocation = CLLocationCoordinate2D()
    var sumDistance = Double()
    var infoTextLabel = UILabel()
    
    let myRecord = Record()     //Realmのデータ保持オブジェクト
    
    required init(coder aDecoder: NSCoder) {
        // GoogleDevelopperのAPIキー
        // AppDelegateだと上手くいかない。（AppDelegateよりinitが先に呼ばれる？）
//        GMSServices.provideAPIKey("AIzaSyAMJxlruTU8bBxQSSTFAR4gVfuINOuKS1M")
        lm = CLLocationManager()
        longitude = CLLocationDegrees()
        latitude = CLLocationDegrees()
        mapView = GMSMapView()
        camera = GMSCameraPosition()
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        GMSServices.provideAPIKey("AIzaSyAMJxlruTU8bBxQSSTFAR4gVfuINOuKS1M")
        lm = CLLocationManager()
        longitude = CLLocationDegrees()
        latitude = CLLocationDegrees()
        mapView = GMSMapView()
        camera = GMSCameraPosition()
        super.init(nibName: nil, bundle: nil)
        //tabBarItemのアイコンをFeaturedに、タグを1と定義する.
        self.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Featured, tag: 1)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.appendCenterButton()
        
        lm = CLLocationManager()
        lm.delegate = self
        
        // セキュリティ認証のステータスを取得
        let status = CLLocationManager.authorizationStatus()
        
        // まだ認証が得られていない場合は、認証ダイアログを表示
        if status == CLAuthorizationStatus.NotDetermined {
            println("didChangeAuthorizationStatus:\(status)");
            // まだ承認が得られていない場合は、認証ダイアログを表示
            self.lm.requestAlwaysAuthorization()
        }
        
        // 取得精度の設定
        lm.desiredAccuracy = kCLLocationAccuracyBest
        // 取得頻度の設定（??m動いたら）
        lm.distanceFilter = 10
        
        self.googleMapInit(latitude, initLongitude: longitude)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func setup() {
//        GMSServices.provideAPIKey("AIzaSyAMJxlruTU8bBxQSSTFAR4gVfuINOuKS1M")
//        lm = CLLocationManager()
//        longitude = CLLocationDegrees()
//        latitude = CLLocationDegrees()
//        mapView = GMSMapView()
//        camera = GMSCameraPosition()
//    }
    
    // GoogleMapの初期設定および生成を行う
    func googleMapInit(initLatitude: CLLocationDegrees, initLongitude: CLLocationDegrees) {
        // 現在地取得開始
        lm.startUpdatingLocation()
        //       camera = GMSCameraPosition.cameraWithLatitude(-33.868,
        //            longitude:151.2086, zoom:15)
        println("\(initLatitude),\(initLongitude)")     // Debug
        // 現在の緯度経度でCamera定義（イミュータブル）
        camera = GMSCameraPosition.cameraWithLatitude(initLatitude,
            longitude:initLongitude, zoom:15)
        // 定義したCameraからMapViewを生成
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera:camera)
        // 現在地にマーカーを立てる
        marker.position = camera.target
        marker.snippet = "現在地"
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        
        // スタートのボタンが押されていれば移動軌跡を表示（このタイミングではきっと押されていないはず）
        poliLine.map = mapView
        poliLine.strokeWidth = 5
        poliLine.strokeColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        if super.mappingStarted {
            self.polylineDrow()
        }
        
        // マップ上に表示する移動距離などのviewを作成
        infoTextLabel = UILabel(frame: CGRect(x: 10,y: 30,width: 130,height: 20))
        infoTextLabel.text = "Total : " + (NSString(format: "%.2f", sumDistance) as String) + "m"
        mapView.addSubview(infoTextLabel)
        self.view = mapView
    }
    
    
    // 位置情報取得成功時
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!){
        
        // 取得した位置情報から経度を設定
        longitude = newLocation.coordinate.longitude
        // 取得した位置情報から緯度を設定
        latitude = newLocation.coordinate.latitude
        //        camera = GMSCameraPosition.cameraWithLatitude(latitude,
        //            longitude:longitude, zoom:6)
        
        // 現在地のCLLocationCoordinate2Dを生成し、MapViewとMarkerの位置を変更
        var location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.animateToLocation(location)
        marker.position = location
        
        
        if super.mappingStarted {
            if fromLocation.latitude.isZero {
                // fromが無ければ、現在地をfromにセット
                fromLocation.latitude = latitude
                fromLocation.longitude = longitude
            } else {
                // 前回のtoをfromにセット
                fromLocation.latitude = toLocation.latitude
                fromLocation.longitude = toLocation.longitude
            }
        
            // 現在地をtoにセット
            toLocation.latitude = latitude
            toLocation.longitude = longitude
        
            // from~toの距離計算
            sumDistance +=
                self.calcLocationDistance(fromLocation, toLocation: toLocation)
        
            // 軌跡の座標をアップデート
            self.polylineDrow()
        }
        
        // debug
        println("sumDistance = " + sumDistance.description)
        infoTextLabel.text = "Total : " + (NSString(format: "%.2f", sumDistance) as String) + "m"
        
        //        self.view.setNeedsDisplay()
        
        //        self.latlonLabel.text = "\(longitude), \(latitude)"
        //        self.googleMapInit(latitude, initLongitude: longitude)
        
        // get address
//                CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
//                    if error != nil {
//                        println("Reverse geocoder failed with error" + error.localizedDescription)
//                        return
//                    }
//                    if placemarks.count > 0 {
//                        let pm = placemarks[0] as! CLPlacemark
//                        //stop updating location to save battery life
//                        self.lm.stopUpdatingLocation()
//                    } else {
//                        println("Problem with the data received from geocoder")
//                    }
//                })
        
    }
    
    // 位置情報表示
    //    func displayLocationInfo(placemark: CLPlacemark) {
    //        var address: String = ""
    //        address = placemark.locality != nil ? placemark.locality : ""
    //        address += ","
    //        address += placemark.postalCode != nil ? placemark.postalCode : ""
    //        address += ","
    //        address += placemark.administrativeArea != nil ? placemark.administrativeArea : ""
    //        address += ","
    //        address += placemark.country != nil ? placemark.country : ""
    ////        self.addressLabel.text = address
    //    }
    
    // 位置情報取得失敗時
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        NSLog("Error while updating location. " + error.localizedDescription)
    }
    
    func getCurrentAddress() {
        
    }
    
    // 位置情報から距離計算
    func calcLocationDistance(fromLocation: CLLocationCoordinate2D, toLocation: CLLocationCoordinate2D) -> (Double) {
        var locationDistance: CLLocationDistance =
        GMSGeometryDistance(fromLocation, toLocation)
        println("distance = " + locationDistance.description)
        return locationDistance
    }
    
    // 現在の緯度経度から軌跡を描画
    func polylineDrow() {
        targetPath.addLatitude(latitude, longitude: longitude)
        poliLine.path = targetPath
        let polylineRecord = PolylineArray()
        polylineRecord.poliLineLatitude = latitude
        polylineRecord.poliLineLongitude = longitude
        myRecord.polyLine.append(polylineRecord)
    }

    // 描画した軌跡と総距離をクリア
    func mappingRestarted() {
        sumDistance = 0
        toLocation.latitude = 0
        toLocation.longitude = 0
        fromLocation.latitude = 0
        fromLocation.longitude = 0
        targetPath.removeAllCoordinates()
        poliLine.path = targetPath
    }
    

    @IBAction override func onClickSpButton(sender: SpringButton) {
    // SpringButtonにアニメーションを設定し実行後、マッピング開始フラグをオンorオフする。
        sender.animation = "pop"
        sender.animate()
        if super.mappingStarted {
            // TODO ここに移動距離と、どこからどこまでと、平均速度、その時のpolylineなどをどっかに記録する処理を追加する
            //      その時にstopするかを聞くようなアラートを出しても良いかも。
            super.mappingStarted = false
            // realmにデータを保存
            myRecord.distance = sumDistance
            myRecord.createdDate = NSDate().timeIntervalSince1970
            let realm = Realm()
            realm.beginWrite()
            realm.add(myRecord)
            realm.commitWrite()
        } else {
            self.mappingRestarted()
            self.polylineDrow()
            super.mappingStarted = true
        }
    }
    
}




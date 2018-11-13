//
//  MapViewController.swift
//  Mitasai
//
//  Created by 勝良祥吾 on 2018/10/04.
//  Copyright © 2018年 shougo.katsura. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var myLatitude: CLLocationDegrees?
    var myLongitude: CLLocationDegrees?
    var circleData: CircleData?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.inputView = searchPickerView
        }
    }
    
    
    private lazy var searchPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.showsSelectionIndicator = true
        return pickerView
    }()
    
    private let searchOptions = ["座って休憩したい","案内所に行きたい","グッズを買いたい","トイレに行きたい","がっつり食べたい!","喉乾いた","甘いものが欲しくなった","ゼミの発表はどこでやっているの？","タバコを吸いたい"]
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return searchOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return searchOptions[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        searchTextField.text = searchOptions[row]
    }
    
    
    var locationManeger = CLLocationManager()
    
    @objc func donePressed(sender: UIBarButtonItem) {
        self.mapView.removeAnnotations(annotationArr)
        annotationArr.removeAll()
        self.mapView.removeAnnotation(myPin)
        switch searchPickerView.selectedRow(inComponent: 0) {
        case 0:
            dropPin(selectedArray: coordinate.restPlace)
        case 1:
            dropPin(selectedArray: coordinate.informationPlace)
        case 2:
            dropPin(selectedArray: coordinate.goodsPlace)
        case 3:
            dropPin(selectedArray: coordinate.toiletPlace)
        case 4:
            dropPin(selectedArray: coordinate.gattsuriPlace)
        case 5:
            dropPin(selectedArray: coordinate.nodoPlace)
        case 6:
            dropPin(selectedArray: coordinate.amaimonoPlace)
        case 7:
            dropPin(selectedArray: coordinate.zemiPlace)
        default:
            dropPin(selectedArray: coordinate.tabakoPlace)
        }
        searchTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        campasButton.setImage(UIImage(named: "キャンパスへ"), for: .highlighted)
        nowPlaceButton.setImage(UIImage(named: "現在位置"), for: .highlighted)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 50))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(MapViewController.donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "選択するとピンが落ちます"
        label.textAlignment = NSTextAlignment.center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([flexSpace,textBtn,flexSpace,doneButton], animated: true)
        searchTextField.inputAccessoryView = toolBar
        
        locationManeger.delegate = self
        CLLocationManager.locationServicesEnabled()
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.notDetermined) {
            print("NotDetermined")
            locationManeger.requestWhenInUseAuthorization()
        }
        locationManeger.startUpdatingLocation()
        mapView.userTrackingMode = MKUserTrackingMode.follow
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        
        let location:CLLocationCoordinate2D
            = CLLocationCoordinate2DMake(35.648964,139.7428)
        mapView.setCenter(location,animated:true)
        var region:MKCoordinateRegion = mapView.region
        region.center = location
        region.span.latitudeDelta = 0.0035
        region.span.longitudeDelta = 0.0035
        mapView.setRegion(region,animated:true)
        
        mapView.mapType = MKMapType.standard
        mapView.isRotateEnabled = false
        
    }
    
    var annotationArr = Array<MKAnnotation>()
    
    func dropPin(selectedArray: [[Any]]) {
        for i in selectedArray {
            let anno = MKPointAnnotation()
            let longi = i[2] as! Double
            let lat = i[3] as! Double
            anno.coordinate = CLLocationCoordinate2DMake(lat,longi)
            anno.title = i[0] as? String
            anno.subtitle = i[1] as? String
            annotationArr.append(anno)
        }
        self.mapView.addAnnotations(annotationArr)
    }
    
    let myPin: MKPointAnnotation = MKPointAnnotation()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        circleData = appDelegate.appDelegateCircleData
        if let circleData = circleData {
            self.mapView.removeAnnotations(annotationArr)
            annotationArr.removeAll()
            searchTextField.text = circleData.name
            judgePlace(place: circleData.place, p: circleData.p)
            myPin.coordinate = CLLocationCoordinate2DMake(myLatitude!, myLongitude!)
            myPin.title = circleData.name
            myPin.subtitle = circleData.place + circleData.detailPlace
            mapView.addAnnotation(myPin)
            appDelegate.appDelegateCircleData = nil
            self.circleData = nil
        } else {
            print("circleDataなし")
        }
    }
    
    func judgePlace(place: String, p: String) {
        switch place {
        case "中庭":
            switch p {
            case "西":
                myLongitude = 139.742258
                myLatitude = 35.649088
            case "東":
                myLongitude = 139.7428
                myLatitude = 35.648984
            case "中央東":
                myLongitude = 139.743315
                myLatitude = 35.648936
            case "中央西":
                myLongitude = 139.742602
                myLatitude = 35.648949
            case "南":
                myLongitude = 139.743342
                myLatitude = 35.648151
            default :
                myLongitude = 139.743202
                myLatitude = 35.648618
            }
        case "第1校舎":
            myLongitude = 139.742838
            myLatitude = 35.649224
        case "南校舎":
            myLongitude = 139.743176
            myLatitude = 35.648360
        case "西校舎":
            myLongitude = 139.742022
            myLatitude = 35.649189
        case "ステージ":
            myLongitude = 139.742843
            myLatitude = 35.648605
        case "ミニステージ":
            myLongitude = 139.742194
            myLatitude = 35.648975
        case "演舞場":
            myLongitude = 139.743717
            myLatitude = 35.649241
        case "リング":
            myLongitude = 139.742213
            myLatitude = 35.648465
        default:
            myLongitude = 139.7428
            myLatitude = 35.648964
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func toNowPlaceButton(_ sender: Any) {
        let lati = locationManeger.location?.coordinate.latitude
        let long = locationManeger.location?.coordinate.longitude
        let location:CLLocationCoordinate2D?
        if let lati = lati, let long = long {
            location = CLLocationCoordinate2DMake(lati,long)
        } else {
            location = CLLocationCoordinate2DMake(35.648964,139.7428)
        }
        mapView.setCenter(location!,animated:true)
        var region:MKCoordinateRegion = mapView.region
        region.center = location!
        region.span.latitudeDelta = 0.0035
        region.span.longitudeDelta = 0.0035
        mapView.setRegion(region,animated:true)
    }
    
    @IBAction func toCampasButton(_ sender: Any) {
        let location:CLLocationCoordinate2D
            = CLLocationCoordinate2DMake(35.648964,139.7428)
        mapView.setCenter(location,animated:true)
        var region:MKCoordinateRegion = mapView.region
        region.center = location
        region.span.latitudeDelta = 0.0035
        region.span.longitudeDelta = 0.0035
        mapView.setRegion(region,animated:true)
        
    }
    
    @IBOutlet weak var campasButton: UIButton!
    @IBOutlet weak var nowPlaceButton: UIButton!
    
}


//
//  DetailStageViewController.swift
//  Mitasai
//
//  Created by 勝良祥吾 on 2018/10/25.
//  Copyright © 2018年 shougo.katsura. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseStorage

class DetailStageViewController: UIViewController, MKMapViewDelegate{
    
    var stageData: StageData?
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var planNameLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var myLatitude: CLLocationDegrees?
    var myLongitude: CLLocationDegrees?
    let myPin: MKPointAnnotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        マップの設定
        let location:CLLocationCoordinate2D
            = CLLocationCoordinate2DMake(35.648964,139.7428)
        mapView.setCenter(location,animated:true)
        var region:MKCoordinateRegion = mapView.region
        region.center = location
        region.span.latitudeDelta = 0.0032
        region.span.longitudeDelta = 0.0032
        mapView.setRegion(region,animated:true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populate(stageData: stageData!)
        //        ピンの設定
        self.mapView.removeAnnotation(myPin)
        switch stageData?.place {
        case "ステージ":
            myLatitude = 35.648565
            myLongitude = 139.742870
        case "ミニステージ":
            myLatitude = 35.649001
            myLongitude = 139.742231
        default:
            myLatitude = 35.649245
            myLongitude = 139.743717
        }
        
        myPin.coordinate = CLLocationCoordinate2DMake(myLatitude!, myLongitude!)
        myPin.title = stageData?.place
        mapView.addAnnotation(myPin)
    }
    
    
    let storage = Storage.storage()
    var imageRef: StorageReference?
    func populate(stageData: StageData) {
        
        titleLabel.title = stageData.name
        timeLabel.text = "\(stageData.day)" + "日" + " " + stageData.startTime + " ~ " + stageData.lastTime
        nameLabel.text = stageData.name
        planNameLabel.text = stageData.planName
        introLabel.text = stageData.intro
        placeLabel.text = stageData.place
        
        imageRef = storage.reference().child(stageData.photo)
        imageRef?.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.topImage.image = UIImage(named: "naimage.png")
            } else {
                self.topImage.image = UIImage(data: data!)
            }
        }
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

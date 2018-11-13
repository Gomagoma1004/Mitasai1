//
//  RankInformationViewController.swift
//  Mitasai
//
//  Created by 勝良祥吾 on 2018/11/06.
//  Copyright © 2018 shougo.katsura. All rights reserved.
//

import UIKit
import MapKit

class RankInformationViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    

    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBOutlet weak var mapView: MKMapView!
    let myPin: MKPointAnnotation = MKPointAnnotation()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myPin.coordinate = CLLocationCoordinate2DMake(35.648605, 139.742843)
        myPin.title = "ステージスクリーン"
        mapView.addAnnotation(myPin)
    }
 
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    let dayLabel = ["22,23日","24日朝 "," 24日  ","25日昼 "]
    let infoLabel = ["全模擬店の中から投票","エリア別1位の結果発表","エリア別1位となった6つの団体から投票","総合大賞・特別賞の結果発表"]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as! infoCell
        cell.populate(d: dayLabel[indexPath.row], i: infoLabel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

class infoCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    func populate(d: String, i: String) {
        dayLabel.text = d
        infoLabel.text = i
    }
    
}

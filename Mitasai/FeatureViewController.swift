//
//  FeatureViewController.swift
//  Mitasai
//
//  Created by 勝良祥吾 on 2018/10/30.
//  Copyright © 2018 shougo.katsura. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import MapKit

class FeatureViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        query = baseQuery()
        tableView.delegate = self
        tableView.dataSource = self
        guruguruMapView.delegate = self
        let location:CLLocationCoordinate2D
            = CLLocationCoordinate2DMake(35.648964,139.744699)
        guruguruMapView.setCenter(location,animated:true)
        var region:MKCoordinateRegion = guruguruMapView.region
        region.center = location
        region.span.latitudeDelta = 0.004
        region.span.longitudeDelta = 0.004
        guruguruMapView.setRegion(region,animated:true)
        
        guruguruMapView.mapType = MKMapType.standard
        guruguruMapView.isRotateEnabled = false
        dropPin(selectedArray: coordinate.guruguruPlace)
        
    }

// 本部企画局用実装
//  tableVeiwの実装
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mitazitsuData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "honkiCell") as! honkiCell
        let cellMitazitsuData = mitazitsuData[indexPath.row]
        cell.populate(mitazitsuData: cellMitazitsuData)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
//  firebaseの読み込み
    var mitazitsuData: [MitazitsuData] = []
    var documents: [DocumentSnapshot] = []
    var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }
    var listener: ListenerRegistration?
    func baseQuery() -> Query {
        return Firestore.firestore().collection("Mitazitsudata")
    }
    func observeQuery() {
        guard let query = query else { return }
        stopObserving()
        
        listener = query.addSnapshotListener { [unowned self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot resules: \(error!)")
                return
            }
            
            let models = snapshot.documents.map { (document) -> MitazitsuData in
                if let model = MitazitsuData(dictionary: document.data()){
                    return model
                } else {
                    fatalError("Unable to initialize type \(self.mitazitsuData.self) with dictionary \(document.data())")
                }
            }
            self.mitazitsuData = models
            self.documents = snapshot.documents
            self.tableView.reloadData()
        }
    }
    
    func stopObserving() {
        listener?.remove()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeQuery()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObserving()
    }
    
// ぐるぐるグルメ用実装
    @IBOutlet weak var guruguruMapView: MKMapView!
    
    var annotationArr = Array<MKAnnotation>()
    func dropPin(selectedArray: [[Any]]) {
        for i in selectedArray {
            let anno = MKPointAnnotation()
            let longi = i[1] as! Double
            let lat = i[2] as! Double
            anno.coordinate = CLLocationCoordinate2DMake(lat,longi)
            anno.title = i[0] as? String
            annotationArr.append(anno)
        }
        self.guruguruMapView.addAnnotations(annotationArr)
    }
    
    
}

class honkiCell: UITableViewCell {
    func populate(mitazitsuData: MitazitsuData) {
    
    }
}

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
import youtube_ios_player_helper

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
        
        fukubikiMap.delegate = self
        let location2:CLLocationCoordinate2D
            = CLLocationCoordinate2DMake(35.648918, 139.742779)
        guruguruMapView.setCenter(location,animated:true)
        var region2:MKCoordinateRegion = guruguruMapView.region
        region2.center = location2
        region2.span.latitudeDelta = 0.003
        region2.span.longitudeDelta = 0.003
        fukubikiMap.setRegion(region2,animated:true)
        
        fukubikiMap.mapType = MKMapType.standard
        fukubikiMap.isRotateEnabled = false
        myPin.title = "福引テント"
        myPin.coordinate = CLLocationCoordinate2DMake(35.649333, 139.742339)
        fukubikiMap.addAnnotation(myPin)
        
        youtube.load(withVideoId: "22PItY4imGE")
    }
// 福引用
    
    @IBOutlet weak var fukubikiMap: MKMapView!
    let myPin: MKPointAnnotation = MKPointAnnotation()
    
    
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
        return Firestore.firestore().collection("Mitazitsudata").order(by: "sort", descending: false)
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
    
    var sendHonkiData: MitazitsuData?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDetailHonkiViewController") {
            let detailStageViewController = segue.destination as! DetailHonkiViewController
            detailStageViewController.honkiData = sendHonkiData
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mitazitsuData[indexPath.row].url.isEmpty {
            sendHonkiData = mitazitsuData[indexPath.row]
            performSegue(withIdentifier: "toDetailHonkiViewController", sender: nil)
        } else {
            let url = URL(string: mitazitsuData[indexPath.row].url)!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
//  オフィシャルソング
    
    @IBOutlet weak var youtube: YTPlayerView!
    

    
    
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
    
    @IBOutlet weak var cellImage: UIImageView!
    
    func populate(mitazitsuData: MitazitsuData) {
        
        let storage = Storage.storage()
        var imageRef: StorageReference?
        imageRef = storage.reference().child(mitazitsuData.cellImage)
        
        imageRef?.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.cellImage.image = UIImage(named: "naimage.png")
            } else {
                self.cellImage.image = UIImage(data: data!)
            }
        }
    }
}

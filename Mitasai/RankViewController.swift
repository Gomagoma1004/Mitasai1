//
//  RankViewController.swift
//  Mitasai
//
//  Created by 勝良祥吾 on 2018/10/19.
//  Copyright © 2018年 shougo.katsura. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class RankViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var underTitleBar: UIView!
    
    let stageColor = UIColor(red: 0.157, green: 0.722, blue: 0.722, alpha: 1.0)
    let centerEastColor = UIColor(red: 0.918, green: 0.329, blue: 0.098, alpha: 1.0)
    let centerWestColor = UIColor(red: 0.949, green: 0.576, blue: 0.149, alpha: 1.0)
    let eastColor = UIColor(red: 0.584, green: 0.271, blue: 0.553, alpha: 1.0)
    let westColor = UIColor(red: 0.459, green: 0.706, blue: 0.267, alpha: 1.0)
    let southColor = UIColor(red: 0.502, green: 0.671, blue: 0.835, alpha: 1.0)
    
    @IBAction func segmentChange(_ sender: Any) {
        
        switch (sender as AnyObject).selectedSegmentIndex {
        case 0:
            areaChack = "ス"
            segmentControl.tintColor = stageColor
            underTitleBar.backgroundColor = stageColor
        case 1:
            areaChack = "中央東"
            segmentControl.tintColor = centerEastColor
            underTitleBar.backgroundColor = centerEastColor
        case 2:
            areaChack = "中央西"
            segmentControl.tintColor = centerWestColor
            underTitleBar.backgroundColor = centerWestColor
        case 3:
            areaChack = "東"
            segmentControl.tintColor = eastColor
            underTitleBar.backgroundColor = eastColor
        case 4:
            areaChack = "西"
            segmentControl.tintColor = westColor
            underTitleBar.backgroundColor = westColor
        default:
            areaChack = "南"
            segmentControl.tintColor = southColor
            underTitleBar.backgroundColor = southColor
        }
        query = baseQuery()
        observeQuery()
    }
    var areaChack = "ス"
    
    //    テーブルビューの表示について
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return circleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankingCell", for: indexPath) as! CircleDataCell
        
        
        let CellcircleData = circleData[indexPath.row]
        cell.populate(circleData: CellcircleData)
        
        if FirstForm! {
            cell.RankImage.image = nil
        } else {
            if indexPath.row == 0 {
                cell.RankImage.image = UIImage(named: "1位")
            } else if indexPath.row == 1 {
                cell.RankImage.image = UIImage(named: "2位")
            } else if indexPath.row == 2 {
                cell.RankImage.image = UIImage(named: "3位")
            } else {
                cell.RankImage.image = nil
            }
        }
        
        switch CellcircleData.p {
        case "ス":
            cell.aroundView.backgroundColor = stageColor
            cell.barView.backgroundColor = stageColor
        case "中央東":
            cell.aroundView.backgroundColor = centerEastColor
            cell.barView.backgroundColor = centerEastColor
        case "中央西":
            cell.aroundView.backgroundColor = centerWestColor
            cell.barView.backgroundColor = centerWestColor
        case "東":
            cell.aroundView.backgroundColor = eastColor
            cell.barView.backgroundColor = eastColor
        case "西":
            cell.aroundView.backgroundColor = westColor
            cell.barView.backgroundColor = westColor
        default:
            cell.aroundView.backgroundColor = UIColor(red: 0.502, green: 0.671, blue: 0.835, alpha: 1.0)
            cell.barView.backgroundColor = UIColor(red: 0.502, green: 0.671, blue: 0.835, alpha: 1.0)
        }
        
        return cell
    }
    //セルの高さを決める
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    //    次のDetailViewに送るための処理
    var sendCircleData: CircleData?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDetailViewController") {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.circleData = sendCircleData
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendCircleData = circleData[indexPath.row]
        performSegue(withIdentifier: "toDetailViewController", sender: nil)
    }
    
    var circleData: [CircleData] = []
    var documents: [DocumentSnapshot] = []
    
    //  Firebaseからとってくるための処理
    
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
        if FirstForm == true {
            return Firestore.firestore().collection("data").whereField("p", isEqualTo: areaChack).order(by: "vote", descending: true)
        } else {
            return Firestore.firestore().collection("data").order(by: "vote", descending: true)
        }
    }
    
    func observeQuery() {
        guard let query = query else { return }
        stopObserving()
        
        listener = query.addSnapshotListener { [unowned self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot resules: \(error!)")
                return
            }
            let models = snapshot.documents.map { (document) -> CircleData in
                if let model = CircleData(dictionary: document.data()) {
                    return model
                } else {
                    fatalError("Unable to initialize type \(CircleData.self) with dictionary \(document.data())")
                }
            }
            self.circleData = models
            self.documents = snapshot.documents
            self.tableView.reloadData()
        }
    }
    
    func stopObserving() {
        listener?.remove()
    }
    
    //   初期画面処理
    override func viewDidLoad() {
        super.viewDidLoad()
        compareDate()
        
        
        query = baseQuery()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeQuery()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObserving()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    deinit {
        listener?.remove()
    }
    
    
    //    日付処理
    let today = Date()
    var calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    var FirstForm: Bool?
    var SecondForm: Bool?
    var ThirdForm: Bool?
    
    func compareDate() {
        let H3 = calendar.date(from: DateComponents(year:2018, month:11, day: 24, hour: 0, minute: 0, second: 0))
        let H4 = calendar.date(from: DateComponents(year:2018, month:11, day: 25, hour: 13, minute: 0, second: 0))
        let compareSecondeChange = today > H3!
        let compareThirdChange = today > H4!
        
        if compareSecondeChange == false && compareThirdChange == false {
            FirstForm = true
            SecondForm = false
            ThirdForm = false
        } else if compareSecondeChange == true && compareThirdChange == false {
            FirstForm = false
            SecondForm = true
            ThirdForm = false
        } else {
            FirstForm = false
            SecondForm = false
            ThirdForm = true
        }
    }
    
    @IBOutlet weak var segmentHeight: NSLayoutConstraint!
    
}

class CircleDataCell: UITableViewCell {
    
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var planNameLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    
    @IBOutlet weak var RankImage: UIImageView!
    
    @IBOutlet weak var aroundView: UIView!
    @IBOutlet weak var barView: UIView!
    
    
    func populate(circleData: CircleData) {
        
        let storage = Storage.storage()
        var imageRef: StorageReference?
        nameLabel.text = circleData.name
        planNameLabel.text = " " + circleData.planName
        placeLabel.text = " " + circleData.detailPlace
        if circleData.vote >= 10 {
            voteLabel.text = String(circleData.vote) + "票"
        } else {
            voteLabel.text = ""
        }
        
        imageRef = storage.reference().child(circleData.photo)
        
        imageRef?.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.cellImageView.image = UIImage(named: "naimage.png")
            } else {
                self.cellImageView.image = UIImage(data: data!)
            }
        }
    }
    
}

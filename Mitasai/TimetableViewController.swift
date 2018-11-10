//
//  TimetableViewController.swift
//  Mitasai
//
//  Created by 勝良祥吾 on 2018/10/01.
//  Copyright © 2018年 shougo.katsura. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class TimetableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // circleDataのタイムテーブル版を作成する
    
    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var selectedDay: Int = 22
    
    
    //データを格納する宣言
    var stageData: [StageData] = []
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
        let db = Firestore.firestore().collection("stageData")
        let dbQuery = db.order(by: "sort", descending: false).whereField("day", isEqualTo: selectedDay).whereField("place", isEqualTo: selectedStage)
        return dbQuery
    }
    
    func observeQuery() {
        guard let query = query else { return }
        stopObserving()
        
        listener = query.addSnapshotListener { [unowned self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot resules: \(error!)")
                return
            }
            
            let models = snapshot.documents.map { (document) -> StageData in
                if let model = StageData(dictionary: document.data()) {
                    return model
                } else {
                    fatalError("Unable to initialize type \(CircleData.self) with dictionary \(document.data())")
                }
            }
            self.stageData = models
            self.documents = snapshot.documents
            self.tableView.reloadData()
        }
    }
    
    func stopObserving() {
        listener?.remove()
    }
    
    //    Viewが表示されたときの処理
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = stageData[indexPath.row]
        let height = CGFloat(Double(data.lengthTime) * 3)
        if height >= 150 {
            return 150
        } else if height >= 75 {
            return height
        } else {
            return 75
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stageCell") as! stageCell
        let cellStageData = stageData[indexPath.row]
        cell.populate(stageData: cellStageData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stageData.count
    }
    
    var sendStageData: StageData?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDetailStageViewController") {
            let detailStageViewController = segue.destination as! DetailStageViewController
            detailStageViewController.stageData = sendStageData
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendStageData = stageData[indexPath.row]
        performSegue(withIdentifier: "toDetailStageViewController", sender: nil)
    }
    
    @IBAction func daySegment(_ sender: Any) {
        switch (sender as AnyObject).selectedSegmentIndex {
        case 0:
            selectedDay = 22
        case 1:
            selectedDay = 23
        case 2:
            selectedDay = 24
        default:
            selectedDay = 25
        }
        query = baseQuery()
        observeQuery()
        
    }
    
    //  ステージを変える処理
    private var selectedStage: String = "ステージ"
    @IBOutlet weak var mainStage: UIButton!
    @IBOutlet weak var miniStage: UIButton!
    @IBOutlet weak var enbu: UIButton!
    @IBOutlet weak var ring: UIButton!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var underTitleView: UIView!
    
    let stageColor = UIColor(red: 0.157, green: 0.722, blue: 0.722, alpha: 1.0)
    let miniStageColor = UIColor(red: 0.149, green: 0.545, blue: 0.227, alpha: 1.0)
    let enbuColor = UIColor(red: 0.486, green: 0.255, blue: 0.584, alpha: 1.0)
    let ringColor = UIColor(red: 0.949, green: 0.576, blue: 0.149, alpha: 1.0)
    
    @IBAction func mainStageButton(_ sender: Any) {
        selectedStage = "ステージ"
        mainStage.setImage(UIImage(named: "メインステージ"), for: .normal)
        miniStage.setImage(UIImage(named: "ミニステージグレー"), for: .normal)
        enbu.setImage(UIImage(named: "演舞場グレー"), for: .normal)
        ring.setImage(UIImage(named: "リンググレー"), for: .normal)
        segment.tintColor = stageColor
        underTitleView.backgroundColor = stageColor
        stageLabel.text = "Main Stage"
        query = baseQuery()
        observeQuery()
    }
    
    @IBAction func miniStageButton(_ sender: Any) {
        selectedStage = "ミニステージ"
        mainStage.setImage(UIImage(named: "メインステージグレー"), for: .normal)
        miniStage.setImage(UIImage(named: "ミニステージ"), for: .normal)
        enbu.setImage(UIImage(named: "演舞場グレー"), for: .normal)
        ring.setImage(UIImage(named: "リンググレー"), for: .normal)
        segment.tintColor = miniStageColor
        underTitleView.backgroundColor = miniStageColor
        stageLabel.text = "Mini Stage"
        query = baseQuery()
        observeQuery()
    }
    
    @IBAction func enbuButton(_ sender: Any) {
        selectedStage = "演舞場"
        mainStage.setImage(UIImage(named: "メインステージグレー"), for: .normal)
        miniStage.setImage(UIImage(named: "ミニステージグレー"), for: .normal)
        enbu.setImage(UIImage(named: "演舞場"), for: .normal)
        ring.setImage(UIImage(named: "リンググレー"), for: .normal)
        segment.tintColor = enbuColor
        underTitleView.backgroundColor = enbuColor
        stageLabel.text = "演舞場"
        query = baseQuery()
        observeQuery()
    }
    
    
    @IBAction func ringButton(_ sender: Any) {
        selectedStage = "リング"
        mainStage.setImage(UIImage(named: "メインステージグレー"), for: .normal)
        miniStage.setImage(UIImage(named: "ミニステージグレー"), for: .normal)
        enbu.setImage(UIImage(named: "演舞場グレー"), for: .normal)
        ring.setImage(UIImage(named: "リング"), for: .normal)
        segment.tintColor = ringColor
        underTitleView.backgroundColor = ringColor
        stageLabel.text = "リング"
        query = baseQuery()
        observeQuery()
    }
    
    
}

class stageCell: UITableViewCell {
    
    let stageColor = UIColor(red: 0.157, green: 0.722, blue: 0.722, alpha: 1.0)
    let miniStageColor = UIColor(red: 0.149, green: 0.545, blue: 0.227, alpha: 1.0)
    let enbuColor = UIColor(red: 0.486, green: 0.255, blue: 0.584, alpha: 1.0)
    let ringColor = UIColor(red: 0.949, green: 0.576, blue: 0.149, alpha: 1.0)
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var leftNameView: UIView!
    
    func populate(stageData: StageData) {
        
        startTimeLabel.text = stageData.startTime
        nameLabel.text = stageData.name
        categoryLabel.text = stageData.category
        
        switch stageData.place {
        case "ステージ":
            leftNameView.backgroundColor = stageColor
        case "ミニステージ":
            leftNameView.backgroundColor = miniStageColor
        case "演舞場":
            leftNameView.backgroundColor = enbuColor
        default:
            leftNameView.backgroundColor = ringColor
        }
        
        switch stageData.category {
        case "展示":
            categoryImage.image = UIImage(named: "展示")
        case "演奏":
            categoryImage.image = UIImage(named: "演奏")
        case "食事":
            categoryImage.image = UIImage(named: "食事")
        case "体験":
            categoryImage.image = UIImage(named: "体験")
        case "講演会":
            categoryImage.image = UIImage(named: "講演会")
        default:
            categoryImage.image = UIImage(named: "パフォーマンス")
        }
        
    }
    
}

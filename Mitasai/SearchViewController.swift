//
//  SearchViewController.swift
//  Mitasai
//
//  Created by 勝良祥吾 on 2018/09/30.
//  Copyright © 2018年 shougo.katsura. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterStackView: UIStackView!
    @IBOutlet weak var filterStackViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nameFilterLabel: UILabel!
    @IBOutlet weak var placeFilterLabel: UILabel!
    @IBOutlet weak var categoryFilterLabel: UILabel!
    
    //データを格納する宣言
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
        return Firestore.firestore().collection("data")
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
    
    lazy private var filter: (navigationController: UINavigationController,
        filterController: FilterViewController) = {
            return FilterViewController.fromStoryboard(delegate: self)
    }()
    
    
    //    Viewが表示されたときの処理
    override func viewDidLoad() {
        super.viewDidLoad()
        query = baseQuery()
        tableView.delegate = self
        tableView.dataSource = self
        
        filterStackView.isHidden = true
        filterStackViewHeight.constant = 0
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
        return 120
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! searchCell
        let CellcircleData = circleData[indexPath.row]
        cell.populate(circleData: CellcircleData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return circleData.count
    }
    
    @IBAction func clearButton(_ sender: Any) {
        filter.filterController.clearFilters()
        controller(filter.filterController, category: nil, place: nil, name: nil)
    }
    
    @IBAction func toFilterButton(_ sender: Any) {
        present(filter.navigationController, animated: true, completion: nil)
    }
    
    
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
    
}

extension SearchViewController: FilterViewControllerDelegate {
    func query(category: String?, place: String?, name: String?) -> Query {
        
        var filtered = baseQuery()
        
        if category == nil && place == nil && name == nil {
            filterStackViewHeight.constant = 0
            filterStackView.isHidden = true
        } else {
            filterStackViewHeight.constant = 55
            filterStackView.isHidden = false
        }
        
        // Advanced queries
        
        if let category = category, !category.isEmpty {
            if category != "選択なし" {
                filtered = filtered.whereField("category", isEqualTo: category)
            }
        }
        
        if let name = name, !name.isEmpty {
            filtered = filtered.whereField("name", isEqualTo: name)
        }
        
        if let place = place, !place.isEmpty {
            filtered = filtered.whereField("place", isEqualTo: place)
        }
        return filtered
    }
    
    func controller(_ controller: FilterViewController,
                    category: String?,
                    place: String?,
                    name: String?
        ) {
        let filtered = query(category: category, place: place, name: name)
        
        if let name = name, !name.isEmpty {
            nameFilterLabel.text = name + " "
            nameFilterLabel.isHidden = false
        } else {
            nameFilterLabel.text = "選択なし"
        }
        
        if let category = category, !category.isEmpty {
            categoryFilterLabel.text = category + " "
            categoryFilterLabel.isHidden = false
        } else {
            categoryFilterLabel.text = "選択なし"
        }
        
        if let place = place, !place.isEmpty {
            placeFilterLabel.text = place + " "
            placeFilterLabel.isHidden = false
        } else {
            placeFilterLabel.text = "選択なし"
        }
        
        self.query = filtered
        observeQuery()
    }
}



class searchCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    func populate(circleData: CircleData) {
        
        switch circleData.category {
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
        
        let storage = Storage.storage()
        var imageRef: StorageReference?
        nameLabel.text = circleData.name
        placeLabel.text =  circleData.place + " " + circleData.detailPlace
        categoryLabel.text = circleData.category
        imageRef = storage.reference().child(circleData.photo)
        
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

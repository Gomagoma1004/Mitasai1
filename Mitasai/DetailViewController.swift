//
//  DetailViewController.swift
//  Mitasai
//
//  Created by 勝良祥吾 on 2018/09/28.
//  Copyright © 2018年 shougo.katsura. All rights reserved.
//

import UIKit
import FirebaseStorage

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UINavigationItem!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var planNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var usedFoodLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    @IBOutlet weak var toVoteButton: UIButton!
    @IBOutlet weak var foodHeight: NSLayoutConstraint!
    @IBOutlet weak var foodStack: UIStackView!
    @IBAction func BackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private var countStacks: Int = 1250
    
    var circleData: CircleData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBOutlet weak var usedFoodUpperLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let circleData = circleData {
            populate(circleData: circleData)
            
            if !circleData.food.isEmpty {
                foodHeight.constant = 160
                foodStack.isHidden = false
                foodLabel.text = circleData.food
                usedFoodLabel.text = circleData.usedFood
                usedFoodUpperLabel.isHidden = false
            } else {
                foodHeight.constant = 0
                foodStack.isHidden = true
            }
            
            if !circleData.intro.isEmpty {
                introLabel.text = circleData.intro
            } else {
                introLabel.text = "みなさまのご来店をお待ちしています！"
            }
            
            judgeVoteButton(place: circleData.place, vote: circleData.vote)
            
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    let storage = Storage.storage()
    var imageRef: StorageReference?
    
    func populate(circleData: CircleData) {
        
        nameLabel.text = circleData.name
        planNameLabel.text = circleData.planName
        titleLabel.title = circleData.name
        timeLabel.text = circleData.time
        placeLabel.text = circleData.place + " " + circleData.detailPlace
        categoryLabel.text = circleData.category
        
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
        
        imageRef = storage.reference().child(circleData.photo)
        imageRef?.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.detailImageView.image = UIImage(named: "naimage.png")
            } else {
                self.detailImageView.image = UIImage(data: data!)
            }
        }
    }
    
    @IBOutlet weak var stackview1: UIView!
    @IBOutlet weak var stackview2: UIView!
    @IBOutlet weak var stackview3: UIView!
    @IBOutlet weak var voteBackgroundView: UIView!
    
    
    func judgeVoteButton(place: String, vote: Int) {
        if place == "中庭" && vote >= 1 {
            toVoteButton.isHidden = false
            stackview1.isHidden = false
            stackview2.isHidden = false
            stackview3.isHidden = false
            voteBackgroundView.isHidden = false
        } else {
            toVoteButton.isHidden = true
            stackview1.isHidden = true
            stackview2.isHidden = true
            stackview3.isHidden = true
            voteBackgroundView.isHidden = true
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toVoteViewController") {
            let voteViewController = segue.destination as! VoteViewController
            voteViewController.getCircleData = circleData
        }
        
    }
    
    
    @IBAction func toMap(){
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.appDelegateCircleData = circleData
        self.tabBarController?.selectedIndex = 0
        
    }
    
}

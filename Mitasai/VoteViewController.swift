//
//  VoteViewController.swift
//  Mitasai
//
//  Created by 勝良祥吾 on 2018/10/04.
//  Copyright © 2018年 shougo.katsura. All rights reserved.
//

import UIKit
import Firebase

class VoteViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var getCircleData: CircleData?
    var newVote: Int?
    
    let Ref = Firestore.firestore().collection("data")
    var VoteRef: DocumentReference?
    var DocumentPath: String?
    
    @IBOutlet weak var voteButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var profileTextfield: UITextField! {
        didSet {
            profileTextfield.inputView = profilePickerView
        }
    }
    
    
    private let profileOptions = ["慶應生","来場者"]
    
    private lazy var profilePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return profileOptions.count
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent: Int) -> String? {
        return profileOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        profileTextfield.text = profileOptions[row]
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        switch profilePickerView.selectedRow(inComponent: 0) {
        case 0:
            profile = "慶應生"
        default:
            profile = "来場者"
        }
        profileTextfield.resignFirstResponder()
    }
    var profile = "慶應生"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 50))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(VoteViewController.donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "選択してください"
        label.textAlignment = NSTextAlignment.center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([flexSpace,textBtn,flexSpace,doneButton], animated: true)
        profileTextfield.inputAccessoryView = toolBar
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        compareDate()
        if FirstForm == true {
            let lastVoteCount = userDefaults.object(forKey: "vote") as! Int
            if lastVoteCount == 1 {
                if let circleData = getCircleData {
                    if profile == "慶應生" {
                        newVote = circleData.vote + 1
                    } else {
                        newVote = circleData.vote + 2
                    }
                    DocumentPath = circleData.name
                    VoteRef = Ref.document(DocumentPath!)
                }
            } else {
                voteButton.isHidden = true
                label.text = "投票ありがとうございました！"
            }
        } else if SecondForm == true {
            let lastVoteCount = userDefaults.object(forKey: "H3Vote") as! Int
            if lastVoteCount == 1 {
                if let circleData = getCircleData {
                    if profile == "慶應生" {
                        newVote = circleData.vote + 1
                    } else {
                        newVote = circleData.vote + 2
                    }
                    DocumentPath = circleData.name
                    VoteRef = Ref.document(DocumentPath!)
                }
            } else {
                voteButton.isHidden = true
                label.text = "投票ありがとうございました！"
            }
        } else {
            voteButton.isHidden = true
            label.text = "中庭模擬店大賞は終了しました！"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var FirstForm: Bool?
    var SecondForm: Bool?
    var ThirdForm: Bool?
    
    let today = Date()
    var calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    func compareDate() {
        let H3 = calendar.date(from: DateComponents(year:2018, month:10, day: 20, hour: 0))
        let H4 = calendar.date(from: DateComponents(year:2018, month:11, day: 25, hour: 13))
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
    
    @IBAction func voteButton(_ sender: Any) {
        
        if let newVote = newVote {
            VoteRef?.updateData([
                "vote": newVote
            ]) {  err in
                if let err = err {
                    print("Error updating document: \(err)")
                }
            }
        }
        voteButton.isHidden = true
        label.text = "ありがとうございます！"
        
        if FirstForm == true {
            userDefaults.set(0, forKey: "vote")
            print(userDefaults.object(forKey: "vote") as! Int)
            userDefaults.synchronize()
        } else {
            userDefaults.set(0, forKey: "H3Vote")
            print(userDefaults.object(forKey: "H3Vote") as! Int)
            userDefaults.synchronize()
        }
        
        
    }
    

}


//
//  HomeViewController.swift
//  Mitasai
//
//  Created by 勝良祥吾 on 2018/10/02.
//  Copyright © 2018年 shougo.katsura. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var welcomeBar: UIView!
    @IBOutlet weak var mitasaiLabel: UILabel!
    
    @IBOutlet weak var mogitenView: UIView!
    @IBOutlet weak var questionnaireView: UIView!
    @IBOutlet weak var mogitenButton: UIButton!
    @IBOutlet weak var questionnaireButton: UIButton!
    @IBOutlet weak var underStack: UIStackView!
    
    var url: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        compareDate()
        if SecondForm! || ThirdForm! || FourthForm! {
            underStack.isHidden = false
            stackHeight.constant = 50
        } else {
            underStack.isHidden = true
            stackHeight.constant = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        let docRef = db.collection("ooizumi").document("url")
        docRef.getDocument{ (document, error) in
            if let document = document {
                self.url = document.get("url") as? String
            }
        }
        
        
        mogitenButton.titleLabel?.minimumScaleFactor = 0.5
        questionnaireButton.titleLabel?.minimumScaleFactor = 0.5
        
        logoImage.frame = CGRect(x: 0, y: -50, width: 150, height: 150)
        logoImage.center = self.view.center
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: { () in
            self.logoImage.transform = CGAffineTransform(scaleX: 0.3, y: 0.3) }, completion: { (Bool) in })
        //拡大させて、消えるアニメーション
        UIView.animate(withDuration:0.5, delay: 0.5, options: UIView.AnimationOptions.curveEaseOut, animations: { () in
            self.logoImage.transform = CGAffineTransform(scaleX: 20, y: 20)
            self.logoImage.alpha = 0
        }, completion: { (Bool) in
            self.logoImage.removeFromSuperview()
        })
        
        UIView.animate(withDuration: 0.5, delay: 1.0 , animations: { () in
            self.topImage.alpha = 1.0
        })
        
        UIView.animate(withDuration: 0.5, delay: 2.0 , animations: { () in
            self.infoImage.alpha = 1.0
        })

        
        UIView.animate(withDuration: 0.5, delay: 3.0 , animations: { () in
            self.mogitenView.alpha = 1.0
            self.questionnaireView.alpha = 1.0
            self.mogitenButton.alpha = 1.0
            self.questionnaireButton.alpha = 1.0
        })
        
        UIView.animate(withDuration: 0.5, delay: 5.0 , animations: { () in
            self.syuruiImage.alpha = 0.9
        })
    }
    @IBOutlet weak var syuruiImage: UIImageView!
    @IBOutlet weak var infoImage: UIImageView!
    
    @IBAction func mogitenActionButton(_ sender: Any) {
        if let tabvc = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController  {
            DispatchQueue.main.async {
                tabvc.selectedIndex = 1
            }
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dstView = storyboard.instantiateViewController(withIdentifier: "RankViewController") as! RankViewController
        self.tabBarController?.navigationController?.present(dstView, animated: true, completion: nil)
    }
    
    @IBAction func questionnaireActionButton(_ sender: Any) {
        //  大泉のアンケートが完成したらここ
        let url = URL(string: self.url!)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    
    
    //    日付処理
    let today = Date()
    var calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    var FirstForm: Bool?
    var SecondForm: Bool?
    var ThirdForm: Bool?
    var FourthForm: Bool?
    
    func compareDate() {
        let H1 = calendar.date(from: DateComponents(year:2018, month:11, day: 22, hour: 9, minute: 30, second: 0))
        let H3 = calendar.date(from: DateComponents(year:2018, month:11, day: 24, hour: 0, minute: 0, second: 0))
        let H4 = calendar.date(from: DateComponents(year:2018, month:11, day: 25, hour: 13, minute: 0, second: 0))
        let compareFirstChange = today > H1!
        let compareSecondChange = today > H3!
        let compareThirdChange = today > H4!
        
        if compareThirdChange {
            FirstForm = false
            SecondForm = false
            ThirdForm = false
            FourthForm = true
        } else if compareSecondChange {
            FirstForm = false
            SecondForm = false
            ThirdForm = true
            FourthForm = false
        } else if compareFirstChange {
            FirstForm = false
            SecondForm = true
            ThirdForm = false
            FourthForm = false
        } else {
            FirstForm = true
            SecondForm = false
            ThirdForm = false
            FourthForm = false
        }
    }
    
    
}

//
//  HomeViewController.swift
//  Mitasai
//
//  Created by 勝良祥吾 on 2018/10/02.
//  Copyright © 2018年 shougo.katsura. All rights reserved.
//

import UIKit

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            self.welcomeLabel.alpha = 1.0
            self.welcomeBar.alpha = 1.0
        })
        
        UIView.animate(withDuration: 0.5, delay: 3.0 , animations: { () in
            self.mitasaiLabel.alpha = 1.0
        })
        
        UIView.animate(withDuration: 0.5, delay: 4.0 , animations: { () in
            self.mogitenView.alpha = 1.0
            self.questionnaireView.alpha = 1.0
            self.mogitenButton.alpha = 1.0
            self.questionnaireButton.alpha = 1.0
        })
    }
    
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
        let url = URL(string: "https://www.google.co.jp/")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

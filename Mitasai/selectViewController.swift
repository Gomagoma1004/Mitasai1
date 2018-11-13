//
//  selectViewController.swift
//  Mitasai
//
//  Created by 勝良祥吾 on 2018/11/13.
//  Copyright © 2018 shougo.katsura. All rights reserved.
//

import UIKit

class selectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        compareDate()
        if SecondForm! || ThirdForm! || FourthForm! {
            button.isHidden = false
        } else {
            button.isHidden = true
        }
    }
    
    @IBOutlet weak var button: UIButton!
    
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

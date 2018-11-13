//
//  DetailHonkiViewController.swift
//  Mitasai
//
//  Created by 勝良祥吾 on 2018/11/09.
//  Copyright © 2018 shougo.katsura. All rights reserved.
//

import UIKit
import FirebaseStorage

class DetailHonkiViewController: UIViewController {
    
    let scrollViewHeight: CGFloat = 5000
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var honkiData: MitazitsuData?

    override func viewDidLoad() {
        super.viewDidLoad()
        heightView.frame.size.height = 5000
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populate(mitazitsuData: honkiData!)
        
    }
    
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var planName: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var guestLabel: UILabel!
    @IBOutlet weak var guestStack: UIStackView!
    @IBOutlet weak var participantsStack: UIStackView!
    @IBOutlet weak var participantsLabel: UILabel!
    

    
    
    
    let storage = Storage.storage()
    var imageRef: StorageReference?
    func populate(mitazitsuData: MitazitsuData) {
        
        if !mitazitsuData.guest.isEmpty {
            guestLabel.text = mitazitsuData.guest
            guestStack.isHidden = false
        } else {
            guestStack.isHidden = true
            guestStack.frame.size.height = 0

        }
        
        if !mitazitsuData.participants.isEmpty {
            participantsLabel.text = mitazitsuData.participants
            participantsStack.isHidden = false
        } else {
            participantsStack.isHidden = true
            participantsStack.frame.size.height = 0
        }

        planName.text = mitazitsuData.planName
        dayLabel.text = mitazitsuData.time
        introLabel.text = mitazitsuData.intro
        placeLabel.text = mitazitsuData.place
        imageRef = storage.reference().child(mitazitsuData.topImage)
        
        imageRef?.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.topImage.image = UIImage(named: "naimage.png")
            } else {
                self.topImage.image = UIImage(data: data!)
            }
        }
    }
    
    
    

}

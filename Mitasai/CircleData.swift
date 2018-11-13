//
//  CircleData.swift
//  Mitasai
//
//  Created by 勝良祥吾 on 2018/09/16.
//  Copyright © 2018年 shougo.katsura. All rights reserved.
//

import Foundation

struct CircleData {
    
    var name: String
    var place: String
    var category: String
    var photo: String
    var intro: String
    var time: String
    var planName: String
    var vote: Int
    var food: String
    var usedFood: String
    var detailPlace: String
    var p: String
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "place": place,
            "category": category,
            "photo": photo,
            "intro": intro,
            "time": time,
            "planName": planName,
            "vote": vote,
            "food": food,
            "usedFood": usedFood,
            "detailPlace": detailPlace,
            "p": p
        ]
    }
}

extension CircleData: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
            let place = dictionary["place"] as? String,
            let category = dictionary["category"] as? String,
            let photo = dictionary["photo"] as? String,
            let intro = dictionary["intro"] as? String,
            let time = dictionary["time"] as? String,
            let planName = dictionary["planName"] as? String,
            let vote = dictionary["vote"] as? Int,
            let food = dictionary["food"] as? String,
            let usedFood = dictionary["usedFood"] as? String,
            let detailPlace = dictionary["detailPlace"] as? String,
            let p = dictionary["p"] as? String
        else {
                return nil
            }
        
        self.init(name: name,
                  place: place,
                  category: category,
                  photo: photo,
                  intro: intro,
                  time: time,
                  planName: planName,
                  vote: vote,
                  food: food,
                  usedFood: usedFood,
                  detailPlace: detailPlace,
                  p: p)
    }
}

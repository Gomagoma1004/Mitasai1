
import Foundation

struct MitazitsuData {
    
    var planName: String
    var url: String
    var time: String
    var sort: Int
    var intro: String
    var place: String
    var cellImage: String
    var topImage: String
    var category: String
    var guest: String
    var participants: String
    
    
    var dictionary: [String: Any] {
        return [
            "planName": planName,
            "url": url,
            "time": time,
            "sort": sort,
            "intro": intro,
            "place": place,
            "cellImage": cellImage,
            "topImage": topImage,
            "category": category,
            "guest": guest,
            "participants": participants
        ]
    }
}

extension MitazitsuData: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard let planName = dictionary["planName"] as? String,
            let url = dictionary["url"] as? String,
            let time = dictionary["time"] as? String,
            let sort = dictionary["sort"] as? Int,
            let intro = dictionary["intro"] as? String,
            let place = dictionary["place"] as? String,
            let cellImage = dictionary["cellImage"] as? String,
            let topImage = dictionary["topImage"] as? String,
            let category = dictionary["category"] as? String,
            let guest = dictionary["guest"] as? String,
            let participants = dictionary["participants"] as? String
        
        
            else {
                return nil
        }
        
        self.init(planName: planName,
                  url: url,
                  time: time,
                  sort: sort,
                  intro: intro,
                  place: place,
                  cellImage: cellImage,
                  topImage: topImage,
                  category: category,
                  guest: guest,
                  participants: participants
        )
    }
    
}

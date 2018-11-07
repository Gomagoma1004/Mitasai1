
import Foundation

struct MitazitsuData {
    
    var name: String
    var place: String
    var category: String
    var photo: String
    var intro: String
    var planName: String
    var lastTime: String
    var startTime: String
    var lengthTime: Int
    var day: Int
    var sort: Int
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "place": place,
            "category": category,
            "photo": photo,
            "intro": intro,
            "planName": planName,
            "lastTime": lastTime,
            "startTime": startTime,
            "lengthTime": lengthTime,
            "day": day,
            "sort": sort
        ]
    }
}

extension MitazitsuData: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
            let place = dictionary["place"] as? String,
            let category = dictionary["category"] as? String,
            let photo = dictionary["photo"] as? String,
            let intro = dictionary["intro"] as? String,
            let planName = dictionary["planName"] as? String,
            let lastTime = dictionary["lastTime"] as? String,
            let startTime = dictionary["startTime"] as? String,
            let lengthTime = dictionary["lengthTime"] as? Int,
            let day = dictionary["day"] as? Int,
            let sort = dictionary["sort"] as? Int
            else {
                return nil
        }
        
        self.init(name: name,
                  place: place,
                  category: category,
                  photo: photo,
                  intro: intro,
                  planName: planName,
                  lastTime: lastTime,
                  startTime: startTime,
                  lengthTime: lengthTime,
                  day: day,
                  sort: sort
            
        )
    }
    
}

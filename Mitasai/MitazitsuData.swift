
import Foundation

struct MitazitsuData {
    
    var name: String
    
    
    var dictionary: [String: Any] {
        return [
            "name": name
        ]
    }
}

extension MitazitsuData: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String
            else {
                return nil
        }
        
        self.init(name: name
        )
    }
    
}

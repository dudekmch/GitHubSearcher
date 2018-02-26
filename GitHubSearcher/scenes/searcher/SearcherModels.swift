import UIKit

enum Searcher {
    
    static func models<T: ResponseModel>(from json: JSON) -> [T]? {
        let modelsJSON: [JSON] = json["items"] as! [JSON]
        return modelsJSON.flatMap { T(json: $0) }
    }
    
    enum Users {
        struct Request {
            let filter: String 
        }
        
        struct Response {
            
            init(json: JSON) {
                self.success = true
                self.models = Searcher.models(from: json) as [User]?
            }
            
            init() {
                self.success = false
            }
            
            var success: Bool
            var models: [User]?
        }
        
        struct ViewModel {
            let usersList: [User]
        }
    }
}

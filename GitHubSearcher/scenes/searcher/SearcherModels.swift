import UIKit

enum Searcher {
    // MARK: Use cases
    
    enum Users {
        struct Request {
            
        }
        
        struct Response {
            init(json: JSON?) {
            self.success = true
            self.json = json
            }
            
            init() {
                self.success = false
            }
            
            var success: Bool
            var json: JSON?
        }
        
        struct ViewModel {
            let usersList: [User]
        }
    }
    
    enum Repositories {
        struct Request {
            
        }
        
        struct Response {
            
        }
        
        struct ViewModel {
            
        }
    }
}

import UIKit

enum UserDetails {
    
    enum Data {
        struct Request {
        }
        
        struct Response {
            init(user: User?) {
                self.user = user
            }
            var user: User?
        }
        
        struct ViewModel {
            init(user: User?) {
                self.user = user
            }
            var user: User?
        }
    }
}

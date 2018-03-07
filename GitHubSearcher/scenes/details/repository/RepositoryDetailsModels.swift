import UIKit

enum RepositoryDetails {
    
    enum Data {
        struct Request {
        }
        
        struct Response {
            init(repository: Repository?){
                self.repository = repository
            }
            var repository: Repository?
        }
        
        struct ViewModel {
            init(repository: Repository?){
                self.repository = repository
            }
            var repository: Repository?
        }
    }
}

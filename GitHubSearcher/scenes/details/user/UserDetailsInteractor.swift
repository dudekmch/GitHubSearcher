import UIKit

protocol UserDetailsBusinessLogic {
    func doSomething(request: UserDetails.Something.Request)
}

protocol UserDetailsDataStore {
    var user: User? { get set }
}

class UserDetailsInteractor: UserDetailsBusinessLogic, UserDetailsDataStore {
    var presenter: UserDetailsPresentationLogic?
    var worker: UserDetailsWorker?
    var user: User?
    
    // MARK: Do something
    
    func doSomething(request: UserDetails.Something.Request) {
        worker = UserDetailsWorker()
        worker?.doSomeWork()
        
        let response = UserDetails.Something.Response()
        presenter?.presentSomething(response: response)
    }
}

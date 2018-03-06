import UIKit

protocol UserDetailsBusinessLogic {
    func getUser()
}

protocol UserDetailsDataStore {
    var user: User? { get set }
}

class UserDetailsInteractor: UserDetailsBusinessLogic, UserDetailsDataStore {
    
    var presenter: UserDetailsPresentationLogic?
    var worker: UserDetailsWorker?
    var user: User?
    
    func getUser() {
        let response = UserDetails.Data.Response.init(user: user)
        presenter?.presentUser(response: response)
    }
   
}

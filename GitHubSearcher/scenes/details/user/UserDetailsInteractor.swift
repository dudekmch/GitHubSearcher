import UIKit

protocol UserDetailsBusinessLogic {
    func getUser()
    func getFollowerList(request: UserDetails.Followers.Request)
}

protocol UserDetailsDataStore {
    var user: User? { get set }
}

class UserDetailsInteractor: UserDetailsBusinessLogic, UserDetailsDataStore {
    
    var presenter: UserDetailsPresentationLogic?
    var worker: UserDetailsWorker?
    var user: User?
    var gitHubApi = GitHubApiService.shared
    
    func getUser() {
        let response = UserDetails.Data.Response.init(user: user)
        presenter?.presentUser(response: response)
    }
    
    func getFollowerList(request: UserDetails.Followers.Request){
        gitHubApi.getExtraDataFor(user: request.user, result: { response in
            self.presenter?.presentUserWithFollowers(response: response)
        })
    }
   
}

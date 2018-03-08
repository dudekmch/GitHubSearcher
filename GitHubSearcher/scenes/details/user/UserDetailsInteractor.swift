import UIKit

protocol UserDetailsBusinessLogic {
    func getUser()
    func addFollowersDataToUser(request: UserDetails.Followers.Request)
    func getUserRepositories(request: UserDetails.UserRepositories.Request)
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
    
    func addFollowersDataToUser(request: UserDetails.Followers.Request){
        gitHubApi.getExtraDataFor(user: request.user, result: { response in
            self.presenter?.presentUserWithFollowers(response: response)
        })
    }
    
    func getUserRepositories(request: UserDetails.UserRepositories.Request){
        gitHubApi.getRepositriesDataForUser(url: request.urlRepositories) { response in
            self.presenter?.presentStarsSumCountFromUserRepositories(response: response)
        }
    }
   
}

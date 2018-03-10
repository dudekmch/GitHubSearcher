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
    var gitHubApi = GitHubApiService.shared
    
    func getUser() {
        guard let user = self.user else { return }
        addFollowersDataToUser(user: user)
    }
    
    private func addFollowersDataToUser(user: User){
        gitHubApi.getExtraDataFor(user: user, result: { response in
            self.getUserRepositoriesFrom(url: user.repositoriesURL, user: response.user)
        })
    }
    
    private func getUserRepositoriesFrom(url: URL, user: User){
        gitHubApi.getRepositriesDataForUser(url: url, user: user) { response in
            self.presenter?.presentUser(response: response, user: user)
        }
    }
   
}

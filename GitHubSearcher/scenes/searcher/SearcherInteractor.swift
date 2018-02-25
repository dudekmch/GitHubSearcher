import UIKit

protocol SearcherBusinessLogic {
    func searchUsers(request: Searcher.Users.Request)
}

protocol SearcherDataStore {
    //var name: String { get set }
}

class SearcherInteractor: SearcherBusinessLogic, SearcherDataStore {
    var presenter: SearcherPresentationLogic?
    var service: GitHubApiService?
    //var name: String = ""
    
    // MARK: Search users
    
    func searchUsers(request: Searcher.Users.Request) {
        service = GitHubApiService.shared
        service?.getUsers()
        
        let response = Searcher.Users.Response()
        presenter?.presentUsers(response: response)
    }
}

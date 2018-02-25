import UIKit

protocol SearcherBusinessLogic {
    func searchUsers(request: Searcher.Users.Request)
    func searchRepositories(request: Searcher.Repositories.Request)
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
    
    func searchRepositories(request: Searcher.Repositories.Request) {
        service = GitHubApiService.shared
        service?.getRepositories()
        
        let response = Searcher.Repositories.Response()
        presenter?.presentRepositories(response: response)
    }
}

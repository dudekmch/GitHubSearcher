import UIKit

protocol SearcherBusinessLogic {
    func searchUsers(request: Searcher.Users.Request)
    func searchRepositories(request: Searcher.Repositories.Request)
    func setDataStore(name: String)
}

protocol SearcherDataStore {
    var name: String? { get set }
}

class SearcherInteractor: SearcherBusinessLogic, SearcherDataStore {
    
    var presenter: SearcherPresentationLogic?
    var service: GitHubApiService?
    var name: String?
    
    // MARK: Search users
    
    func searchUsers(request: Searcher.Users.Request) {
        service = GitHubApiService.shared
        service?.getUsers()
        
        let response = Searcher.Users.Response()
        presenter?.presentUsers(response: response)
    }
    
    //MARK: Search repositories
    
    func searchRepositories(request: Searcher.Repositories.Request) {
        service = GitHubApiService.shared
        service?.getRepositories()
        
        let response = Searcher.Repositories.Response()
        presenter?.presentRepositories(response: response)
    }
    
    //MARK: Set data store
    
    func setDataStore(name: String){
        self.name = name
    }
}

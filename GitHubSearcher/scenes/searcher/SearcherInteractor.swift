import UIKit

protocol SearcherBusinessLogic {
    func searchUsers(request: Searcher.Data.Request)
    func searchRepositories(request: Searcher.Repositories.Request)
    func setDataStore(name: String, filterType: FilterType)
}

protocol SearcherDataStore {
    var name: String? { get set }
    var filterType: FilterType? { get set }
}

class SearcherInteractor: SearcherBusinessLogic, SearcherDataStore {

    var presenter: SearcherPresentationLogic?
    var service: GitHubApiService?
    var name: String?
    var filterType: FilterType?

    // MARK: Search users

    func searchUsers(request: Searcher.Data.Request) {
        service = GitHubApiService.shared
        service?.searchUsers(filter: request.searchTerm, result: { (response) in

            self.presenter?.presentUsers(response: response)
        })
    }

    //MARK: Search repositories

    func searchRepositories(request: Searcher.Repositories.Request) {
        GitHubApiService.shared.searchRepositories(filter: request.filter, result: { (response) in
            
             self.presenter?.presentRepositories(response: response)
        })

        
       
    }

    //MARK: Set data store

    func setDataStore(name: String, filterType: FilterType) {
        self.name = name
        self.filterType = filterType
    }
}

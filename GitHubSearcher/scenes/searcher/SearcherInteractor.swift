import UIKit

protocol SearcherBusinessLogic {
    func searchData(request: Searcher.Data.Request)
    func setDataStore(name: String, filterType: FilterType)
}

protocol SearcherDataStore {
    var name: String? { get set }
    var filterType: FilterType? { get set }
}

class SearcherInteractor: SearcherBusinessLogic, SearcherDataStore {

    var presenter: SearcherPresentationLogic?
    var service = GitHubApiService.shared
    var name: String?
    var filterType: FilterType?

    // MARK: Search data

    func searchData(request: Searcher.Data.Request) {
        searchDataFrom(filterType: request.filterType, for: request.searchTerm)
    }

    private func searchDataFrom(filterType filter: FilterType, for term: String) {
        switch filter {
        case .users:
            service.searchUsers(searchTerm: term, result: { (response) in
                self.presenter?.presentUsers(response: response)
            })
        case .repositories:
            service.searchRepositories(searchTerm: term, result: { (response) in
                self.presenter?.presentRepositories(response: response)
            })
        }
    }
    
//MARK: Set data store

    func setDataStore(name: String, filterType: FilterType) {
        self.name = name
        self.filterType = filterType
    }
}

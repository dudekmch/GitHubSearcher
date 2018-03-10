import UIKit

protocol SearcherBusinessLogic {
    func searchData(request: Searcher.Data.Request)
    func loadMoreData(request: Searcher.Data.Request)
    var userForDetailsView: User? { get set }
    var repositoryForDetailsView: Repository? { get set }
    var filterType: FilterType? { get set }
}

protocol SearcherDataStore {
    var userForDetailsView: User? { get set }
    var repositoryForDetailsView: Repository? { get set }
    var filterType: FilterType? { get set }
}

class SearcherInteractor: SearcherBusinessLogic, SearcherDataStore {

    var userForDetailsView: User?
    var repositoryForDetailsView: Repository?
    var filterType: FilterType?

    var presenter: SearcherPresentationLogic?
    var gitHubApiService = GitHubApiService.shared

    var totalCountOfPages: Int = 0
    var currentPageNumber: Int = 0
    var nextPageNumber: Int = 0


    // MARK: Search data

    func searchData(request: Searcher.Data.Request) {
        searchDataDispatcher(request: request, pagination: false)
        filterType = request.filterType
    }

    func loadMoreData(request: Searcher.Data.Request) {
        searchDataDispatcher(request: request, pagination: true)
    }

    private func searchDataDispatcher(request: Searcher.Data.Request, pagination: Bool) {
        if pagination {
            loadMoreData(filterType: request.filterType, for: request.searchTerm)

        } else {
            initialSearchDataFrom(filterType: request.filterType, for: request.searchTerm)
        }
    }

    private func initialSearchDataFrom(filterType filter: FilterType, for term: String) {
        self.totalCountOfPages = 0
        self.currentPageNumber = 1
        self.nextPageNumber = self.currentPageNumber + 1
        switch filter {
        case .users:
            gitHubApiService.searchUsers(searchTerm: term, page: currentPageNumber, result: { (response) in
                guard let countOfPages = response.countOfPages else { return }
                self.totalCountOfPages = countOfPages
                self.presenter?.presentUsers(response: response)
            })

        case .repositories:
            gitHubApiService.searchRepositories(searchTerm: term, page: currentPageNumber, result: { (response) in
                guard let countOfPages = response.countOfPages else { return }
                self.totalCountOfPages = countOfPages
                self.presenter?.presentRepositories(response: response)
            })
        }
    }


    private func loadMoreData(filterType filter: FilterType, for term: String) {
        if currentPageNumber >= totalCountOfPages { return }
        switch filter {
        case .users:
            gitHubApiService.searchUsers(searchTerm: term, page: nextPageNumber, result: { (response) in
                guard let countOfPages = response.countOfPages else { return }
                self.totalCountOfPages = countOfPages
                self.presenter?.presentMoreUsers(response: response)
            })
        case .repositories:
            gitHubApiService.searchRepositories(searchTerm: term, page: nextPageNumber, result: { (response) in
                guard let countOfPages = response.countOfPages else { return }
                self.totalCountOfPages = countOfPages
                self.presenter?.presentMoreRepositories(response: response)
            })
        }
        self.currentPageNumber = self.nextPageNumber
        self.nextPageNumber += 1
    }
    
}



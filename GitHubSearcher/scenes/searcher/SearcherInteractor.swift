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
                self.downloadAvatars(for: response, presenterMethod: { response in
                    self.presenter?.presentUsers(response: response)
                })
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
        switch filter {
        case .users:
            if currentPageNumber >= totalCountOfPages {
                let noMorePageResponse = Searcher.Data.Response<User>.init()
                self.presenter?.presentMoreUsers(response: noMorePageResponse)
                return
            }
            gitHubApiService.searchUsers(searchTerm: term, page: nextPageNumber, result: { (response) in
                self.downloadAvatars(for: response, presenterMethod: { response in
                    self.presenter?.presentMoreUsers(response: response)
                })
            })
        case .repositories:
            if currentPageNumber >= totalCountOfPages {
                let noMorePageResponse = Searcher.Data.Response<Repository>.init()
                self.presenter?.presentMoreRepositories(response: noMorePageResponse)
                return
            }
            gitHubApiService.searchRepositories(searchTerm: term, page: nextPageNumber, result: { (response) in
                self.presenter?.presentMoreRepositories(response: response)
            })
        }
        self.currentPageNumber = self.nextPageNumber
        self.nextPageNumber += 1
    }

    private func downloadAvatars(for usersResponse: Searcher.Data.Response<User>, presenterMethod: @escaping (_ response: Searcher.Data.Response<User>) -> ()) {
        guard let users = usersResponse.models else {
            self.presenter?.presentMoreUsers(response: usersResponse)
            return
        }
        var handledUserCounter = 0
        for user in users {
            guard let avatarURL = user.avatarURL else { return }
            URLSession.shared.dataTask(with: avatarURL, completionHandler: { (data, responseURL, errorURL) -> Void in
                if errorURL != nil {
                    print(errorURL!)
                    return
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    user.avatarImage = UIImage(data: data!)
                    handledUserCounter += 1
                    if handledUserCounter == users.count {
                        presenterMethod(usersResponse)
                    }
                })
            }).resume()
        }
    }
}



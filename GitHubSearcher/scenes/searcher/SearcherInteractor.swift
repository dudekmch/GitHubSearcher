import UIKit

protocol SearcherBusinessLogic {
    func searchData(request: Searcher.Data.Request)
    func loadMoreData(request: Searcher.Data.Request)
    func setDataStore(name: String, filterType: FilterType)
}

protocol SearcherDataStore {
    var name: String? { get set }
    var filterType: FilterType? { get set }
}

class SearcherInteractor: SearcherBusinessLogic, SearcherDataStore {

    var presenter: SearcherPresentationLogic?
    var gitHubApiService = GitHubApiService.shared
    var name: String?
    var filterType: FilterType?
    var totalCountOfPages: Int = 0
    var currentPageNumber: Int = 0
    var nextPageNumber: Int = 0

    // MARK: Search data

    func searchData(request: Searcher.Data.Request) {
        searchDataDispatcher(request: request, pagination: false)
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
                print("count of pages: \(countOfPages)")
                self.downloadAvatars(for: response)
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
                self.downloadAvatars(for: response)
            })
        case .repositories:
            gitHubApiService.searchRepositories(searchTerm: term, page: nextPageNumber, result: { (response) in
                guard let countOfPages = response.countOfPages else { return }
                self.totalCountOfPages = countOfPages
                self.presenter?.presentRepositories(response: response)
            })
        }
        self.currentPageNumber = self.nextPageNumber
        self.nextPageNumber += 1
    }
    
    private func initianlUserSearch(for usersResponse: Searcher.Data.Response<User>) {
        guard let countOfPages = usersResponse.countOfPages else { return }
        self.totalCountOfPages = countOfPages
        self.downloadAvatars(for: usersResponse)
    }

    private func userSearchWithPagination(for usersResponse: Searcher.Data.Response<User>) {
        guard let countOfPages = usersResponse.countOfPages else { return }
        self.totalCountOfPages = countOfPages
        if self.currentPageNumber > self.totalCountOfPages { return }
        self.currentPageNumber += 1
        self.downloadAvatars(for: usersResponse)
    }

    private func downloadAvatars(for usersResponse: Searcher.Data.Response<User>) {
        guard let users = usersResponse.models else { return }
        var handledUserCounter = 0
        for user in users {
            guard let avatarURL = user.avatarURL else { return }
            URLSession.shared.dataTask(with: avatarURL, completionHandler: { (data, responseURL, errorURL) -> Void in
                if errorURL != nil {
                    print(errorURL ?? "error")
                    return
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    user.avatarImage = UIImage(data: data!)
                    handledUserCounter += 1
                    if handledUserCounter == users.count {
                        self.presenter?.presentUsers(response: usersResponse)
                    }
                })
            }).resume()

        }
    }

//MARK: Set data store

    func setDataStore(name: String, filterType: FilterType) {
        self.name = name
        self.filterType = filterType
    }
}


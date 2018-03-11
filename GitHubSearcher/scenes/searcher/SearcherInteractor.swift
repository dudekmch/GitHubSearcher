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
        if currentPageNumber >= totalCountOfPages { return }
        switch filter {
        case .users:
            gitHubApiService.searchUsers(searchTerm: term, page: nextPageNumber, result: { (response) in
                guard let countOfPages = response.countOfPages else { return }
                self.totalCountOfPages = countOfPages
                self.downloadAvatars(for: response, presenterMethod: { response in
                     self.presenter?.presentMoreUsers(response: response)
                })
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

    private func downloadAvatars(for usersResponse: Searcher.Data.Response<User>, presenterMethod: @escaping (_ response: Searcher.Data.Response<User>) -> ())  {
        guard let users = usersResponse.models else { return }
        var handledUserCounter = 0
//        let dispatchQueue = DispatchQueue(label: "pl.cookieIT.gitHubSearcher.avatarDownloading", qos: .userInteractive)
        for user in users {
            guard let avatarURL = user.avatarURL else { return }
            //TODO: change qos ??!! This solution is slow
//            dispatchQueue.async {
//                do {
//                    let imageData = try Data.init(contentsOf: avatarURL)
//                    let image = UIImage.init(data: imageData)
//                    user.avatarImage = image
//                    handledUserCounter += 1
//                    if handledUserCounter == users.count {
//                        self.presenter?.presentUsers(response: usersResponse)
//                    }
//                } catch {
//                    print(error)
//                }
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



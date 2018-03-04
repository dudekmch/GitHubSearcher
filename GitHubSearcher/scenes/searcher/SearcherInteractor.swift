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
    var gitHubApiService = GitHubApiService.shared
    var name: String?
    var filterType: FilterType?

    // MARK: Search data

    func searchData(request: Searcher.Data.Request) {
        searchDataFrom(filterType: request.filterType, for: request.searchTerm)
    }

    private func searchDataFrom(filterType filter: FilterType, for term: String) {
        switch filter {
        case .users:
            gitHubApiService.searchUsers(searchTerm: term, result: { (response) in
                self.downloadAvatars(for: response)
            })

        case .repositories:
            gitHubApiService.searchRepositories(searchTerm: term, result: { (response) in
                self.presenter?.presentRepositories(response: response)
            })
        }
    }

    private func downloadAvatars(for usersResponse: Searcher.Data.Response<User>){
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


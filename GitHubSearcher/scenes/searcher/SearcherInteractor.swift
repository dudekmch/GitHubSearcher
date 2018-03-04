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
    var imgDownloadService = ImageDownloadService.shared
    var worker = SearcherWorker()
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
                guard let users = response.models else { return }
                var usersWithAvatar = [User]()
                self.imgDownloadService.getImagae(for: users, result: { user in
                   usersWithAvatar.append(user)
                    if(users.count == usersWithAvatar.count){
                        let response = Searcher.Data.Response.init(data: usersWithAvatar)
                         self.presenter?.presentUsers(response: response)
                    }
                })
                
            })
        case .repositories:
            gitHubApiService.searchRepositories(searchTerm: term, result: { (response) in
                self.presenter?.presentRepositories(response: response)
            })
        }
    }

//    private func downloadAvatarForUsers(response: Searcher.Data.Response<User>) {
//        guard let userList = response.models else { return }
//        var usersWithAvatar = Array<User>()
//        for user in userList {
//            guard let avatarUrl = user.avatarURL else { return }
//            worker.getDataFromUrl(url: avatarUrl, completion: { data, response, error in
//                guard let data = data, error == nil else { return }
//                DispatchQueue.main.async() {
//                    user.avatarImage = UIImage(data: data)
//                    usersWithAvatar.append(user)
//                }
//                if(usersWithAvatar.count != userList.count){
//                let userWithAvatarResponse = Searcher.Data.Response.init(models: usersWithAvatar)
//                self.presenter?.presentUsers(response: userWithAvatarResponse)
//                }
//            })
//        }
//        let usersWithAvatar = userList.map { userWithOutAvatar in
//            guard let avatarUrl = userWithOutAvatar.avatarURL else { return }
//            worker.getDataFromUrl(url: avatarUrl, completion: { data, response, error in
//                guard let data = data, error == nil else { return }
//                DispatchQueue.main.async() {
//                    userWithOutAvatar.avatarImage = UIImage(data: data)
//                }
//            })
//    }
//    }

//MARK: Set data store

    func setDataStore(name: String, filterType: FilterType) {
        self.name = name
        self.filterType = filterType
    }
}


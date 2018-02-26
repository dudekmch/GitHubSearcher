import UIKit

protocol SearcherPresentationLogic {
    func presentUsers(response: Searcher.Users.Response)
    func presentRepositories(response: Searcher.Repositories.Response)
}

class SearcherPresenter: SearcherPresentationLogic {
    weak var viewController: SearcherDisplayLogic?
    
    // MARK: Do something
    
    func presentUsers(response: Searcher.Users.Response) {
        var userList = [User?]()
        if let json = response.json {
            if let responsObjectList = json["items"] as? [JSON]{
                print(responsObjectList)
                for map in responsObjectList {
                    userList.append(User(json: map))
                }
            }
        }
        print(userList)
        print("no json :(")
//        let viewModel = Searcher.Users.ViewModel(usersList: <#T##[User]#>)
//        viewController?.displayUsers(viewModel: viewModel)
    }
    
    func presentRepositories(response: Searcher.Repositories.Response) {
        let viewModel = Searcher.Repositories.ViewModel()
        viewController?.displayRepositories(viewModel: viewModel)
    }
}

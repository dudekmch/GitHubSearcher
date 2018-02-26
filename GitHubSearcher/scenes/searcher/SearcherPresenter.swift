import UIKit

protocol SearcherPresentationLogic {
    func presentUsers(response: Searcher.Users.Response)
//    func presentRepositories(response: Searcher.Repositories.Response)
}

class SearcherPresenter: SearcherPresentationLogic {
    weak var viewController: SearcherDisplayLogic?

    // MARK: Do something

    func presentUsers(response: Searcher.Users.Response) {
        guard let userList = response.models else { return }
        let sortedUserList = userList.sorted { $0.id < $1.id }
        let viewModel = Searcher.Users.ViewModel(usersList: sortedUserList)
        viewController?.displayUsers(viewModel: viewModel)
    }

//    func presentRepositories(response: Searcher.Repositories.Response) {
//        let viewModel = Searcher.Repositories.ViewModel()
//        viewController?.displayRepositories(viewModel: viewModel)
//    }
}

import UIKit

protocol SearcherPresentationLogic {
    func presentUsers(response: Searcher.Users.Response)
    func presentRepositories(response: Searcher.Repositories.Response)
}

class SearcherPresenter: SearcherPresentationLogic {
    weak var viewController: SearcherDisplayLogic?

    // MARK: Do something

    func presentUsers(response: Searcher.Users.Response) {
        guard let userList = response.models else { return }
        let viewModel = Searcher.Users.ViewModel(usersList: userList.sorted { $0.id < $1.id })
        viewController?.displayUsers(viewModel: viewModel)
    }

    func presentRepositories(response: Searcher.Repositories.Response) {
        guard let repositoryList = response.models else { return }
        let viewModel = Searcher.Repositories.ViewModel(repositoryList: repositoryList.sorted { $0.id < $1.id })
        viewController?.displayRepositories(viewModel: viewModel)
    }
}

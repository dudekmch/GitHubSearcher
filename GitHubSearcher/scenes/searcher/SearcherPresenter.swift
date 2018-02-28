import UIKit

protocol SearcherPresentationLogic {
    func presentUsers(response: Searcher.Data.Response<User>)
    func presentRepositories(response: Searcher.Data.Response<Repository>)
}

class SearcherPresenter: SearcherPresentationLogic {
    weak var viewController: SearcherDisplayLogic?

    // MARK: Do something

    func presentUsers(response: Searcher.Data.Response<User>) {
        guard let userList = response.models else { return }
        let viewModel = Searcher.Data.ViewModel(dataList: userList.sorted { $0.id < $1.id })
        viewController?.displayUsers(viewModel: viewModel)
    }

    func presentRepositories(response: Searcher.Data.Response<Repository>) {
        guard let repositoryList = response.models else { return }
        let viewModel = Searcher.Data.ViewModel(dataList: repositoryList.sorted { $0.id < $1.id })
        viewController?.displayRepositories(viewModel: viewModel)
    }
}

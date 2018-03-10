import UIKit

protocol SearcherPresentationLogic {
    func presentUsers(response: Searcher.Data.Response<User>)
    func presentRepositories(response: Searcher.Data.Response<Repository>)
    func presentMoreUsers(response: Searcher.Data.Response<User>)
    func presentMoreRepositories(response: Searcher.Data.Response<Repository>)
}

class SearcherPresenter: SearcherPresentationLogic {
    weak var viewController: SearcherDisplayLogic?

    // MARK: Do something

    func presentUsers(response: Searcher.Data.Response<User>) {
        guard let userList = response.models else { return }
        let viewModel = Searcher.Data.ViewModel(dataList: userList)
        viewController?.displayUsers(viewModel: viewModel)
    }
    
    func presentMoreUsers(response: Searcher.Data.Response<User>) {
        guard let userList = response.models else { return }
        let viewModel = Searcher.Data.ViewModel(dataList: userList)
        viewController?.displayMoreUsers(viewModel: viewModel)
    }

    func presentRepositories(response: Searcher.Data.Response<Repository>) {
        guard let repositoryList = response.models else { return }
        let viewModel = Searcher.Data.ViewModel(dataList: repositoryList)
        viewController?.displayRepositories(viewModel: viewModel)
    }
    
    func presentMoreRepositories(response: Searcher.Data.Response<Repository>) {
        guard let repositoryList = response.models else { return }
        let viewModel = Searcher.Data.ViewModel(dataList: repositoryList)
        viewController?.displayMoreRepositories(viewModel: viewModel)
    }
}

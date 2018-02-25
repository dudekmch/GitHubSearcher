import UIKit

protocol SearcherPresentationLogic {
    func presentUsers(response: Searcher.Users.Response)
    func presentRepositories(response: Searcher.Repositories.Response)
}

class SearcherPresenter: SearcherPresentationLogic {
    weak var viewController: SearcherDisplayLogic?
    
    // MARK: Do something
    
    func presentUsers(response: Searcher.Users.Response) {
        let viewModel = Searcher.Users.ViewModel()
        viewController?.displayUsers(viewModel: viewModel)
    }
    
    func presentRepositories(response: Searcher.Repositories.Response) {
        let viewModel = Searcher.Repositories.ViewModel()
        viewController?.displayRepositories(viewModel: viewModel)
    }
}

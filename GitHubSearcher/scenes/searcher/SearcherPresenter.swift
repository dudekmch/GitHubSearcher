import UIKit

protocol SearcherPresentationLogic {
    func presentUsers(response: Searcher.Users.Response)
}

class SearcherPresenter: SearcherPresentationLogic {
    weak var viewController: SearcherDisplayLogic?
    
    // MARK: Do something
    
    func presentUsers(response: Searcher.Users.Response) {
        let viewModel = Searcher.Users.ViewModel()
        viewController?.displayUsers(viewModel: viewModel)
    }
}

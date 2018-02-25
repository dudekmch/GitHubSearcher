import UIKit

protocol RepositoryDetailsPresentationLogic {
    func presentSomething(response: RepositoryDetails.Something.Response)
}

class RepositoryDetailsPresenter: RepositoryDetailsPresentationLogic {
    weak var viewController: RepositoryDetailsDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: RepositoryDetails.Something.Response) {
        let viewModel = RepositoryDetails.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}

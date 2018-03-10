import UIKit

protocol RepositoryDetailsPresentationLogic {
    func presentRepository(response: RepositoryDetails.Data.Response)
}

class RepositoryDetailsPresenter: RepositoryDetailsPresentationLogic {
    weak var viewController: RepositoryDetailsDisplayLogic?


    func presentRepository(response: RepositoryDetails.Data.Response) {
        let viewModel = RepositoryDetails.Data.ViewModel(repository: response.repository)
        viewController?.displayRepository(viewModel: viewModel)
    }
}

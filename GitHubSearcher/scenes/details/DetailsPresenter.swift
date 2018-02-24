import UIKit

protocol DetailsPresentationLogic {
    func presentSomething(response: Details.Something.Response)
}

class DetailsPresenter: DetailsPresentationLogic {
    weak var viewController: DetailsDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: Details.Something.Response) {
        let viewModel = Details.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}

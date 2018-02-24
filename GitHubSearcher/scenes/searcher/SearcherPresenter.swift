import UIKit

protocol SearcherPresentationLogic {
    func presentSomething(response: Searcher.Something.Response)
}

class SearcherPresenter: SearcherPresentationLogic {
    weak var viewController: SearcherDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: Searcher.Something.Response) {
        let viewModel = Searcher.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}

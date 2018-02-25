import UIKit

protocol UserDetailsPresentationLogic {
    func presentSomething(response: UserDetails.Something.Response)
}

class UserDetailsPresenter: UserDetailsPresentationLogic {
    weak var viewController: UserDetailsDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: UserDetails.Something.Response) {
        let viewModel = UserDetails.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}

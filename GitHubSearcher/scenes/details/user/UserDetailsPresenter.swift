import UIKit

protocol UserDetailsPresentationLogic {
    func presentUser(response: UserDetails.Data.Response)
}

class UserDetailsPresenter: UserDetailsPresentationLogic {
    weak var viewController: UserDetailsDisplayLogic?
    
    func presentUser(response: UserDetails.Data.Response) {
        let viewModel = UserDetails.Data.ViewModel(user: response.user)
        viewController?.displayUserDetails(viewModel: viewModel)
    }
}

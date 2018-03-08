import UIKit

protocol UserDetailsPresentationLogic {
    func presentUser(response: UserDetails.Data.Response)
    func presentUserWithFollowers(response: UserDetails.Followers.Response)
}

class UserDetailsPresenter: UserDetailsPresentationLogic {
    weak var viewController: UserDetailsDisplayLogic?
    
    func presentUser(response: UserDetails.Data.Response) {
        let viewModel = UserDetails.Data.ViewModel(user: response.user)
        viewController?.displayUserDetails(viewModel: viewModel)
    }
    
    func presentUserWithFollowers(response: UserDetails.Followers.Response) {
        let viewModel = UserDetails.Followers.ViewModel.init(userWithFollowers: response.user)
        viewController?.displayFollowersCount(viewModel: viewModel)
    }
}

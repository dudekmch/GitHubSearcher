import UIKit

protocol UserDetailsPresentationLogic {
    func presentUser(response: UserDetails.UserWithFollowersAndRepositories.Response, user: User?)
}

class UserDetailsPresenter: UserDetailsPresentationLogic {
    weak var viewController: UserDetailsDisplayLogic?
    
    func presentUser(response: UserDetails.UserWithFollowersAndRepositories.Response, user: User?){
        let starsSum = response.models?.map({ repo -> Int in
            guard let stars = repo.stars else { return 0 }
            return stars
        })
        guard let sum = starsSum, let userWithFollowers = user  else { return }
        let viewModel = UserDetails.UserWithFollowersAndRepositories.ViewModel.init(allStarsFromRepositories: sum.reduce(0, +), userWithFollowers: userWithFollowers)
        viewController?.displayUserDetails(viewModel: viewModel)
    }
}

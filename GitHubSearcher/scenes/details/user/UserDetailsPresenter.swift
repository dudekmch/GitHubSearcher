import UIKit

protocol UserDetailsPresentationLogic {
    func presentUser(response: UserDetails.Data.Response)
    func presentUserWithFollowers(response: UserDetails.Followers.Response)
    func presentStarsSumCountFromUserRepositories(response: UserDetails.UserRepositories.Response)
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
    
    func presentStarsSumCountFromUserRepositories(response: UserDetails.UserRepositories.Response){
        let starsSum = response.models?.map({ repo -> Int in
            guard let stars = repo.stars else { return 0 }
            return stars
        })
        guard let sum = starsSum else { return }
        let viewModel = UserDetails.UserRepositories.ViewModel.init(allStarsFromRepositories: sum.reduce(0, +))
        viewController?.displayUserRepositoriesStars(viewModel: viewModel)
    }
}

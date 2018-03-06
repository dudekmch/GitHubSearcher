import UIKit

@objc protocol SearcherRoutingLogic {
    func routeToDetails()
}

class SearcherRouter: NSObject, SearcherRoutingLogic {
    weak var viewController: SearcherViewController?
    var dataStore: SearcherDataStore?
    
    func routeToDetails() {
        guard let filter = dataStore?.filterType else { return }
        switch filter {
        case .users:
            showUserDetails()
        case .repositories:
            showRepositoryDetails()
        }
    }
    
    private func showUserDetails() {
        let storyboard = UIStoryboard(name: "UserDetails", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "UserDetailsViewController") as! UserDetailsViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToUserDetails(source: dataStore!, destination: &destinationDS)
        navigateToUserDetails(source: viewController!, destination: destinationVC)
    }
    
    private func showRepositoryDetails() {
        let storyboard = UIStoryboard(name: "RepositoryDetails", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "RepositoryDetailsViewController") as! RepositoryDetailsViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToRepositoryDetails(source: dataStore!, destination: &destinationDS)
        navigateToRepositoryDetails(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    private func navigateToUserDetails(source: SearcherViewController, destination: UserDetailsViewController) {
        source.show(destination, sender: nil)
    }
    
    private func navigateToRepositoryDetails(source: SearcherViewController, destination: RepositoryDetailsViewController) {
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    private func passDataToUserDetails(source: SearcherDataStore, destination: inout UserDetailsDataStore) {
       destination.user = source.userForDetailsView
    }
    
    private func passDataToRepositoryDetails(source: SearcherDataStore, destination: inout RepositoryDetailsDataStore) {
       destination.repository = source.repositoryForDetailsView
    }
}


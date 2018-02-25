import UIKit

@objc protocol SearcherRoutingLogic {
    func routeToDetails()
}

protocol SearcherDataPassing {
    var dataStore: SearcherDataStore? { get }
}

class SearcherRouter: NSObject, SearcherRoutingLogic, SearcherDataPassing {
    weak var viewController: SearcherViewController?
    var dataStore: SearcherDataStore?
    
    func routeToDetails(){
        let storyboard = UIStoryboard(name: "Details", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToDetails(source: dataStore!, destination: &destinationDS)
        navigateToDetails(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToDetails(source: SearcherViewController, destination: DetailsViewController)
    {
        source.show(destination, sender: nil)
    }
    
    //     MARK: Passing data
    
    func passDataToDetails(source: SearcherDataStore, destination: inout DetailsDataStore)
    {
        destination.name = source.name!
    }
}

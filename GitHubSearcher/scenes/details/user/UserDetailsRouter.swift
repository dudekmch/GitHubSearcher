//
//  UserDetailsRouter.swift
//  GitHubSearcher
//
//  Created by Pawel Dudek on 25.02.2018.
//  Copyright (c) 2018 cookieIT. All rights reserved.
//

import UIKit

@objc protocol UserDetailsRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol UserDetailsDataPassing {
    var dataStore: UserDetailsDataStore? { get }
}

class UserDetailsRouter: NSObject, UserDetailsRoutingLogic, UserDetailsDataPassing {
    weak var viewController: UserDetailsViewController?
    var dataStore: UserDetailsDataStore?
    
    // MARK: Routing
    
    //func routeToSomewhere(segue: UIStoryboardSegue?)
    //{
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}
    
    // MARK: Navigation
    
    //func navigateToSomewhere(source: UserDetailsViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: UserDetailsDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}

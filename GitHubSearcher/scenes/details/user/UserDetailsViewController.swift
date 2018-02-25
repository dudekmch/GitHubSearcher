//
//  UserDetailsViewController.swift
//  GitHubSearcher
//
//  Created by Pawel Dudek on 25.02.2018.
//  Copyright (c) 2018 cookieIT. All rights reserved.
//

import UIKit

protocol UserDetailsDisplayLogic: class {
    func displaySomething(viewModel: UserDetails.Something.ViewModel)
}

class UserDetailsViewController: UIViewController, UserDetailsDisplayLogic {
    var interactor: UserDetailsBusinessLogic?
    var router: (NSObjectProtocol & UserDetailsRoutingLogic & UserDetailsDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = UserDetailsInteractor()
        let presenter = UserDetailsPresenter()
        let router = UserDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething() {
        let request = UserDetails.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: UserDetails.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}

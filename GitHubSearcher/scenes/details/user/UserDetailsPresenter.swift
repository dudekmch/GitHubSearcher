//
//  UserDetailsPresenter.swift
//  GitHubSearcher
//
//  Created by Pawel Dudek on 25.02.2018.
//  Copyright (c) 2018 cookieIT. All rights reserved.
//

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

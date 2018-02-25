//
//  RepositoryDetailsPresenter.swift
//  GitHubSearcher
//
//  Created by Pawel Dudek on 25.02.2018.
//  Copyright (c) 2018 cookieIT. All rights reserved.
//

import UIKit

protocol RepositoryDetailsPresentationLogic {
    func presentSomething(response: RepositoryDetails.Something.Response)
}

class RepositoryDetailsPresenter: RepositoryDetailsPresentationLogic {
    weak var viewController: RepositoryDetailsDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: RepositoryDetails.Something.Response) {
        let viewModel = RepositoryDetails.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}

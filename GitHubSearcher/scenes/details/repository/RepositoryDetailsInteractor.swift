//
//  RepositoryDetailsInteractor.swift
//  GitHubSearcher
//
//  Created by Pawel Dudek on 25.02.2018.
//  Copyright (c) 2018 cookieIT. All rights reserved.
//

import UIKit

protocol RepositoryDetailsBusinessLogic {
    func doSomething(request: RepositoryDetails.Something.Request)
}

protocol RepositoryDetailsDataStore {
    //var name: String { get set }
}

class RepositoryDetailsInteractor: RepositoryDetailsBusinessLogic, RepositoryDetailsDataStore {
    var presenter: RepositoryDetailsPresentationLogic?
    var worker: RepositoryDetailsWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: RepositoryDetails.Something.Request) {
        worker = RepositoryDetailsWorker()
        worker?.doSomeWork()
        
        let response = RepositoryDetails.Something.Response()
        presenter?.presentSomething(response: response)
    }
}

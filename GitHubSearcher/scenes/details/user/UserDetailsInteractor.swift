//
//  UserDetailsInteractor.swift
//  GitHubSearcher
//
//  Created by Pawel Dudek on 25.02.2018.
//  Copyright (c) 2018 cookieIT. All rights reserved.
//

import UIKit

protocol UserDetailsBusinessLogic {
    func doSomething(request: UserDetails.Something.Request)
}

protocol UserDetailsDataStore {
    //var name: String { get set }
}

class UserDetailsInteractor: UserDetailsBusinessLogic, UserDetailsDataStore {
    var presenter: UserDetailsPresentationLogic?
    var worker: UserDetailsWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: UserDetails.Something.Request) {
        worker = UserDetailsWorker()
        worker?.doSomeWork()
        
        let response = UserDetails.Something.Response()
        presenter?.presentSomething(response: response)
    }
}

import UIKit

protocol RepositoryDetailsBusinessLogic {
    func doSomething(request: RepositoryDetails.Something.Request)
}

protocol RepositoryDetailsDataStore {
    var repository: Repository? { get set }
}

class RepositoryDetailsInteractor: RepositoryDetailsBusinessLogic, RepositoryDetailsDataStore {
    var presenter: RepositoryDetailsPresentationLogic?
    var worker: RepositoryDetailsWorker?
    var repository: Repository?
    
    // MARK: Do something
    
    func doSomething(request: RepositoryDetails.Something.Request) {
        worker = RepositoryDetailsWorker()
        worker?.doSomeWork()
        
        let response = RepositoryDetails.Something.Response()
        presenter?.presentSomething(response: response)
    }
}

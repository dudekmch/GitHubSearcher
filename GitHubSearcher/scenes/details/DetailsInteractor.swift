import UIKit

protocol DetailsBusinessLogic {
    func doSomething(request: Details.Something.Request)
}

protocol DetailsDataStore {
    //var name: String { get set }
}

class DetailsInteractor: DetailsBusinessLogic, DetailsDataStore {
    var presenter: DetailsPresentationLogic?
    var worker: DetailsWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: Details.Something.Request) {
        worker = DetailsWorker()
        worker?.doSomeWork()
        
        let response = Details.Something.Response()
        presenter?.presentSomething(response: response)
    }
}

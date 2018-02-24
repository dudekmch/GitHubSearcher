import UIKit

protocol SearcherBusinessLogic {
    func doSomething(request: Searcher.Something.Request)
}

protocol SearcherDataStore {
    //var name: String { get set }
}

class SearcherInteractor: SearcherBusinessLogic, SearcherDataStore {
    var presenter: SearcherPresentationLogic?
    var worker: SearcherWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: Searcher.Something.Request) {
        worker = SearcherWorker()
        worker?.doSomeWork()
        
        let response = Searcher.Something.Response()
        presenter?.presentSomething(response: response)
    }
}

import UIKit

protocol RepositoryDetailsBusinessLogic {
    func getRepository()
}

protocol RepositoryDetailsDataStore {
    var repository: Repository? { get set }
}

class RepositoryDetailsInteractor: RepositoryDetailsBusinessLogic, RepositoryDetailsDataStore {
    var presenter: RepositoryDetailsPresentationLogic?
    var worker: RepositoryDetailsWorker?
    var repository: Repository?
    
    func getRepository() {
        let response = RepositoryDetails.Data.Response.init(repository: repository)
        presenter?.presentRepository(response: response)
    }
}

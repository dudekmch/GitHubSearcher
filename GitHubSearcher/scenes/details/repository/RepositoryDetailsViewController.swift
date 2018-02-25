import UIKit

protocol RepositoryDetailsDisplayLogic: class {
    func displaySomething(viewModel: RepositoryDetails.Something.ViewModel)
}

class RepositoryDetailsViewController: UIViewController, RepositoryDetailsDisplayLogic {
    var interactor: RepositoryDetailsBusinessLogic?
    var router: (NSObjectProtocol & RepositoryDetailsRoutingLogic & RepositoryDetailsDataPassing)?
    
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
        let interactor = RepositoryDetailsInteractor()
        let presenter = RepositoryDetailsPresenter()
        let router = RepositoryDetailsRouter()
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
        self.navigationController?.isNavigationBarHidden = false
        usersTableView.delegate = self
        usersTableView.dataSource = self
        doSomething()
    }
    
    // MARK: Do something
    
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var usersTableView: UITableView!
    
    func doSomething() {
        let request = RepositoryDetails.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: RepositoryDetails.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}

extension RepositoryDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        return UITableViewCell()
    }
    
    
}

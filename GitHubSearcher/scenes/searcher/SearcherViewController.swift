import UIKit

typealias JSON = Dictionary<String, Any>

protocol SearcherDisplayLogic: class {
    func displayUsers(viewModel: Searcher.Users.ViewModel)
    func displayRepositories(viewModel: Searcher.Repositories.ViewModel)
}

class SearcherViewController: UIViewController, SearcherDisplayLogic {
    var interactor: SearcherBusinessLogic?
    var router: (NSObjectProtocol & SearcherRoutingLogic & SearcherDataPassing)?
    
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
        let interactor = SearcherInteractor()
        let presenter = SearcherPresenter()
        let router = SearcherRouter()
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
        searcherTableView.delegate = self
        searcherTableView.dataSource = self
        searcherTextField.delegate = self
        registerNib(identifire: UserTableViewCell.identifier)
        registerNib(identifire: RepositoryTableViewCell.identifier)
        self.navigationController?.isNavigationBarHidden = true
        searchUsers()
    }
    
    //MARK: Properties
    
    @IBOutlet weak var searcherTextField: UITextField!
    @IBOutlet weak var searcherTableView: UITableView!
    
    private let mockNumberOfRowsInSection = 15
    
    
    func searchUsers() {
        let request = Searcher.Users.Request()
        interactor?.searchUsers(request: request)
    }
    
    func displayUsers(viewModel: Searcher.Users.ViewModel) {
        //nameTextField.text = viewModel.name
    }
    
    func searchRepositories() {
        let request = Searcher.Repositories.Request()
        interactor?.searchRepositories(request: request)
    }
    
    func displayRepositories(viewModel: Searcher.Repositories.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}

//MARK: Methods of TableViewDelegate, DataSource

extension SearcherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockNumberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UserTableViewCell()
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }
    
    private func registerNib(identifire: String) {
        let nib = UINib(nibName: identifire, bundle: nil)
        searcherTableView.register(nib, forCellReuseIdentifier: identifire)
    }
}

//MARK: Methods of UITextFieldDelegate

extension SearcherViewController: UITextFieldDelegate {
    
}

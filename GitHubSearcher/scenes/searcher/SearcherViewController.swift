import UIKit

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
    private var userList: [User]?
    private var repositoryList: [Repository]?
    
    
    func searchUsers() {
        let request = Searcher.Users.Request(filter: "pa")
        interactor?.searchUsers(request: request)
    }
    
    func displayUsers(viewModel: Searcher.Users.ViewModel) {
        userList = viewModel.usersList
        searcherTableView.reloadData()
    }
    
    func searchRepositories() {
        let request = Searcher.Repositories.Request(filter: "zo")
        interactor?.searchRepositories(request: request)
    }
    
    func displayRepositories(viewModel: Searcher.Repositories.ViewModel) {
        self.repositoryList = viewModel.repositoryList
        searcherTableView.reloadData()
    }
}

//MARK: Methods of TableViewDelegate, DataSource

extension SearcherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let userList = self.userList else { return 0 }
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UserTableViewCell()
        guard let userList = self.userList else { return cell }
        cell.textLabel?.text = String(userList[indexPath.row].id)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mockDataStorName = "name"
        interactor?.setDataStore(name: mockDataStorName, filterType: .repositories)
        router?.routeToDetails()
    }
    
    private func registerNib(identifire: String) {
        let nib = UINib(nibName: identifire, bundle: nil)
        searcherTableView.register(nib, forCellReuseIdentifier: identifire)
    }
}

//MARK: Methods of UITextFieldDelegate

extension SearcherViewController: UITextFieldDelegate {
    
}

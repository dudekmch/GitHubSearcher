import UIKit

protocol SearcherDisplayLogic: class {
    func displayUsers(viewModel: Searcher.Users.ViewModel)
    func displayRepositories(viewModel: Searcher.Repositories.ViewModel)
}

class SearcherViewController: UIViewController, SearcherDisplayLogic {
    var interactor: SearcherBusinessLogic?
    var router: (NSObjectProtocol & SearcherRoutingLogic & SearcherDataPassing)?
    var filterTypeViewHandler: (FilterTypeDisplayingLogic & FilterTypeButtonsLogic & FilterTypeValue & FilterTypeButtonConfigurator)?

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
        let filterTypeViewHandler = FilterTypeViewHandler()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        viewController.filterTypeViewHandler = filterTypeViewHandler
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
        filterTypeView.isHidden = true
        filterTypeViewHandler?.configureDefaultFilterTypeButtonsProperties(setUserFilterTypeButton, setRepositoryFilterTypeButton)
        filterTypeViewHandler?.configureShowFilterTypeViewButton(showFilterTypeViewButton)
        searcherTextField.addTarget(self, action: #selector(searcherTextFieldDidChange(_:)),
            for: UIControlEvents.editingChanged)
        showFilterTypeViewButton.addTarget(self, action: #selector(filterTypeDisplayingHandler(_:)), for: UIControlEvents.touchUpInside)
        setUserFilterTypeButton.addTarget(self, action: #selector(usersFilterTypeButtonHandler(_:)), for: UIControlEvents.touchUpInside)
        setRepositoryFilterTypeButton.addTarget(self, action: #selector(repositoriesFilterTypeButtonHandler(_:)), for: UIControlEvents.touchUpInside)
    }

    //MARK: Properties

    @IBOutlet weak var searcherTextField: UITextField!
    @IBOutlet weak var searcherTableView: UITableView!
    @IBOutlet weak var filterTypeView: UIView!
    @IBOutlet weak var showFilterTypeViewButton: UIButton!
    @IBOutlet weak var setUserFilterTypeButton: UIButton!
    @IBOutlet weak var setRepositoryFilterTypeButton: UIButton!
    
    private var userList: [User]?
    private var repositoryList: [Repository]?


    private func searchUsers(for filter: String) {
        let request = Searcher.Users.Request(filter: filter)
        interactor?.searchUsers(request: request)
    }

    func displayUsers(viewModel: Searcher.Users.ViewModel) {
        userList = viewModel.usersList
        searcherTableView.reloadData()
    }

    private func searchRepositories(for filter: String) {
        let request = Searcher.Repositories.Request(filter: filter)
        interactor?.searchRepositories(request: request)
    }

    func displayRepositories(viewModel: Searcher.Repositories.ViewModel) {
        self.repositoryList = viewModel.repositoryList
        searcherTableView.reloadData()
    }

    @objc private func searcherTextFieldDidChange(_ textField: UITextField) {
        guard let searchText = textField.text else { return }
        filterTypeViewHandler?.filterTypeViewHandler(of: filterTypeView)
        searchUsers(for: searchText)
    }

    @objc private func filterTypeDisplayingHandler(_ button: UIButton) {
        filterTypeViewHandler?.filterTypeViewHandler(of: filterTypeView)
    }
    
    @objc private func usersFilterTypeButtonHandler(_ button: UIButton){
        filterTypeViewHandler?.usersFilterTypeButtonSelected(setUserFilterTypeButton, setRepositoryFilterTypeButton, in: filterTypeView)
    }
    
    @objc private func repositoriesFilterTypeButtonHandler(_ button: UIButton){
        filterTypeViewHandler?.repositoriesFilterTypeButtonSelected(setUserFilterTypeButton, setRepositoryFilterTypeButton, in: filterTypeView)
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
        cell.textLabel?.text = userList[indexPath.row].login
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mockDataStorName = "name"
        interactor?.setDataStore(name: mockDataStorName, filterType: .users)
        router?.routeToDetails()
    }

    private func registerNib(identifire: String) {
        let nib = UINib(nibName: identifire, bundle: nil)
        searcherTableView.register(nib, forCellReuseIdentifier: identifire)
    }
}

//MARK: Methods of UITextFieldDelegate

extension SearcherViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {

    }
}

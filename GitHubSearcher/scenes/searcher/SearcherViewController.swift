import UIKit

protocol SearcherDisplayLogic: class {
    func displayUsers(viewModel: Searcher.Data.ViewModel<User>)
    func displayRepositories(viewModel: Searcher.Data.ViewModel<Repository>)
}

protocol SearchViewData {
    var userList: [User]? { get }
    var repositoryList: [Repository]? { get }
    var avatarList: [UIImage]? { get set }
}

protocol FilterTypeViewUIElements {
    var filterTypeView: UIView! { get set }
    var showFilterTypeViewButton: UIButton! { get set }
    var setUserFilterTypeButton: UIButton! { get set }
    var setRepositoryFilterTypeButton: UIButton! { get set }
}

class SearcherViewController: UIViewController, SearcherDisplayLogic, SearchViewData, FilterTypeViewUIElements {
    var interactor: SearcherBusinessLogic?
    var router: (NSObjectProtocol & SearcherRoutingLogic & SearcherDataPassing)?
    var filterTypeViewHandler: (FilterTypeDisplayingLogic & FilterTypeButtonsLogic & FilterTypeValue & FilterTypeButtonConfigurator)?
    var dataTableViewHandler: DataTableViewProvider?
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
        let filterTypeViewHandler = FilterTypeViewHandler(of: self)
        let dataTableViewProvider = DataTableViewHandler(of: self)
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        viewController.filterTypeViewHandler = filterTypeViewHandler
        viewController.dataTableViewHandler = dataTableViewProvider
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
        searchTermTextField.delegate = self
        registerNib(identifire: UserTableViewCell.identifier)
        registerNib(identifire: RepositoryTableViewCell.identifier)
        preparUIElements()
    }

    //MARK: Properties

    @IBOutlet weak var searchTermTextField: UITextField!
    @IBOutlet weak var searcherTableView: UITableView!
    @IBOutlet weak var filterTypeView: UIView!
    @IBOutlet weak var showFilterTypeViewButton: UIButton!
    @IBOutlet weak var setUserFilterTypeButton: UIButton!
    @IBOutlet weak var setRepositoryFilterTypeButton: UIButton!

    var userList: [User]?
    var repositoryList: [Repository]?
    var avatarList: [UIImage]?


    private func searchData(with filter: FilterType, for searchTerm: String) {
        guard let filterType = filterTypeViewHandler?.currentFilterType else { return }
        let request = Searcher.Data.Request(searchTerm: searchTerm, filterType: filterType)
        interactor?.searchData(request: request)
    }

    func displayUsers(viewModel: Searcher.Data.ViewModel<User>) {
        userList = viewModel.dataList
        searcherTableView.reloadData()
    }

    func displayRepositories(viewModel: Searcher.Data.ViewModel<Repository>) {
        self.repositoryList = viewModel.dataList
        searcherTableView.reloadData()
    }

    private func preparUIElements() {
        self.navigationController?.isNavigationBarHidden = true
        filterTypeView.isHidden = true
        filterTypeViewHandler?.configureDefaultFilterTypeButtonsProperties()
        filterTypeViewHandler?.configureShowFilterTypeViewButton()
        searchTermTextField.addTarget(self, action: #selector(searcherTextFieldDidChange(_:)),
            for: UIControlEvents.editingChanged)
        showFilterTypeViewButton.addTarget(self, action: #selector(filterTypeDisplayingHandler(_:)), for: UIControlEvents.touchUpInside)
        setUserFilterTypeButton.addTarget(self, action: #selector(usersFilterTypeButtonHandler(_:)), for: UIControlEvents.touchUpInside)
        setRepositoryFilterTypeButton.addTarget(self, action: #selector(repositoriesFilterTypeButtonHandler(_:)), for: UIControlEvents.touchUpInside)
    }
    //TODO: dynamic get data
    @objc private func searcherTextFieldDidChange(_ textField: UITextField) {
//        guard let searchText = textField.text, let filterType = filterTypeViewHandler?.currentFilterType else { return }
//        filterTypeViewHandler?.beginTypingHide(view: filterTypeView)
//        searchData(with: filterType, for: searchText)
    }

    @objc private func filterTypeDisplayingHandler(_ button: UIButton) {
        filterTypeViewHandler?.filterTypeViewHandler()
        hideKeyboard()
    }

    @objc private func usersFilterTypeButtonHandler(_ button: UIButton) {
        filterTypeViewHandler?.usersFilterTypeButtonSelected()
    }

    @objc private func repositoriesFilterTypeButtonHandler(_ button: UIButton) {
        filterTypeViewHandler?.repositoriesFilterTypeButtonSelected()
    }

    private func hideKeyboard() {
        self.view.endEditing(true)
    }
}

//MARK: Methods of TableViewDelegate, DataSource

extension SearcherViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataTableViewHandler = self.dataTableViewHandler else { return 0 }
        return dataTableViewHandler.getDataListCount(for: filterTypeViewHandler?.currentFilterType)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataTableViewHandler = self.dataTableViewHandler else { return UITableViewCell() }
        return dataTableViewHandler.prepareCellWithData(for: filterTypeViewHandler?.currentFilterType, with: indexPath, register: tableView)
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        if let filterType = filterTypeViewHandler?.currentFilterType, let searchTerm = searchTermTextField.text {
            filterTypeViewHandler?.beginTypingHideView()
            searchData(with: filterType, for: searchTerm)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        filterTypeViewHandler?.beginTypingHideView()
    }
}

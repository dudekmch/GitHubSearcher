import UIKit

protocol SearcherDisplayLogic: class {
    func displayUsers(viewModel: Searcher.Data.ViewModel<User>)
    func displayRepositories(viewModel: Searcher.Data.ViewModel<Repository>)
    func displayMoreUsers(viewModel: Searcher.Data.ViewModel<User>)
    func displayMoreRepositories(viewModel: Searcher.Data.ViewModel<Repository>)
    func turnOffLoadingIndicatorView()
}

protocol SearchViewData {
    var userList: [User]? { get set }
    var repositoryList: [Repository]? { get set }
}

protocol FilterTypeViewUIElements {
    var filterTypeView: UIView! { get set }
    var showFilterTypeViewButton: UIButton! { get set }
    var setUserFilterTypeButton: UIButton! { get set }
    var setRepositoryFilterTypeButton: UIButton! { get set }
    var sortButton: UIButton! { get set }
}

class SearcherViewController: UIViewController, SearcherDisplayLogic, SearchViewData, FilterTypeViewUIElements {
    var interactor: SearcherBusinessLogic?
    var router: (NSObjectProtocol & SearcherRoutingLogic)?
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

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        searcherTableView.delegate = self
        searcherTableView.dataSource = self
        searchTermTextField.delegate = self
        self.registerNib(identifire: UserTableViewCell.identifier, target: searcherTableView)
        self.registerNib(identifire: RepositoryTableViewCell.identifier, target: searcherTableView)
        preparUIElements()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    //MARK: Properties

    @IBOutlet weak var searchTermTextField: UITextField!
    @IBOutlet weak var searcherTableView: UITableView!
    @IBOutlet weak var filterTypeView: UIView!
    @IBOutlet weak var showFilterTypeViewButton: UIButton!
    @IBOutlet weak var setUserFilterTypeButton: UIButton!
    @IBOutlet weak var setRepositoryFilterTypeButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!


    var userList: [User]?
    var repositoryList: [Repository]?

    private let percentDisplayedCellToLoadNewData = 90
    private let secondDelayOfRequestSending: Double = 1


    @objc private func searchData() {
        guard let searchTerm = searchTermTextField.text, let filterType = filterTypeViewHandler?.currentFilterType else { return }
        if !searchTerm.isEmpty {
            userList = [User]()
            repositoryList = [Repository]()
            searcherTableView.reloadData()
            scrollToFirstRow()
            loadingIndicatorView.startAnimating()
            let request = Searcher.Data.Request(searchTerm: searchTerm, filterType: filterType)
            interactor?.searchData(request: request)
        }
    }

    private func loadMoreData() {
        guard let searchTerm = searchTermTextField.text, let filterType = filterTypeViewHandler?.currentFilterType else { return }
        loadingIndicatorView.startAnimating()
        let request = Searcher.Data.Request(searchTerm: searchTerm, filterType: filterType)
        interactor?.loadMoreData(request: request)
    }

    func displayMoreUsers(viewModel: Searcher.Data.ViewModel<User>) {
        self.userList?.append(contentsOf: viewModel.dataList)
        searcherTableView.reloadData()
        loadingIndicatorView.stopAnimating()
    }

    func displayMoreRepositories(viewModel: Searcher.Data.ViewModel<Repository>) {
        self.repositoryList?.append(contentsOf: viewModel.dataList)
        searcherTableView.reloadData()
        loadingIndicatorView.stopAnimating()
    }

    func displayUsers(viewModel: Searcher.Data.ViewModel<User>) {
        userList = viewModel.dataList
        searcherTableView.reloadData()
        loadingIndicatorView.stopAnimating()
    }

    func displayRepositories(viewModel: Searcher.Data.ViewModel<Repository>) {
        repositoryList = viewModel.dataList
        searcherTableView.reloadData()
        loadingIndicatorView.stopAnimating()
    }
    
    func turnOffLoadingIndicatorView(){
        loadingIndicatorView.stopAnimating()
    }

    private func preparUIElements() {
        self.navigationController?.isNavigationBarHidden = true
        filterTypeView.isHidden = true
        filterTypeViewHandler?.configureDefaultFilterTypeButtonsProperties()
        filterTypeViewHandler?.configureShowFilterTypeViewButton()
        searchTermTextField.addTarget(self, action: #selector(searcherTextFieldDidChange(_:)),
            for: UIControlEvents.editingChanged)
        filterTypeViewHandler?.setupSortButton()
        showFilterTypeViewButton.addTarget(self, action: #selector(filterTypeDisplayingHandler(_:)), for: UIControlEvents.touchUpInside)
        setUserFilterTypeButton.addTarget(self, action: #selector(usersFilterTypeButtonHandler(_:)), for: UIControlEvents.touchUpInside)
        setRepositoryFilterTypeButton.addTarget(self, action: #selector(repositoriesFilterTypeButtonHandler(_:)), for: UIControlEvents.touchUpInside)
        sortButton.addTarget(self, action: #selector(sortDataList), for: UIControlEvents.touchUpInside)
        loadingIndicatorView.hidesWhenStopped = true
    }

    @objc private func filterTypeDisplayingHandler(_ button: UIButton) {
        loadingIndicatorView.isHidden = true
        filterTypeViewHandler?.filterTypeViewHandler()
        hideKeyboard()
    }

    @objc private func usersFilterTypeButtonHandler(_ button: UIButton) {
        filterTypeViewHandler?.usersFilterTypeButtonSelected()
    }

    @objc private func repositoriesFilterTypeButtonHandler(_ button: UIButton) {
        filterTypeViewHandler?.repositoriesFilterTypeButtonSelected()
    }

    @objc private func searcherTextFieldDidChange(_ button: UIButton) {
        filterTypeViewHandler?.beginTypingHideFilterView()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchData), object: nil)
        delaySearchData()
    }

    @objc private func sortDataList(_ button: UIButton) {
        dataTableViewHandler?.sortData(for: filterTypeViewHandler?.currentFilterType)
        searcherTableView.reloadData()
    }

    private func delaySearchData() {
        self.perform(#selector(searchData), with: nil, afterDelay: secondDelayOfRequestSending)
    }

    private func hideKeyboard() {
        self.view.endEditing(true)
    }

    private func scrollToFirstRow() {
        self.searcherTableView.setContentOffset(CGPoint.zero, animated: false)
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
        guard let filter = interactor?.filterType else { return }
        prepareDataForDetailsView(filterType: filter, cellIndexRow: indexPath.row)
        showDetailsView(filterType: filter)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == countPercentOfDisplayedCells() {
            loadMoreData()
        }
    }

    private func countPercentOfDisplayedCells() -> Int {
        guard let dataTableViewHandler = self.dataTableViewHandler else { return 0 }
        let result = dataTableViewHandler.getDataListCount(for: filterTypeViewHandler?.currentFilterType) - 20
        return Int(result)
    }

    private func prepareDataForDetailsView(filterType: FilterType, cellIndexRow: Int) {
        switch filterType {
        case .users:
            guard let users = userList else { return }
            interactor?.userForDetailsView = users[cellIndexRow]
        case .repositories:
            guard let repositories = repositoryList else { return }
            interactor?.repositoryForDetailsView = repositories[cellIndexRow]
        }
    }

    private func showDetailsView(filterType: FilterType) {
        switch filterType {
        case .users:
            router?.routeToDetails()
        case .repositories:
            router?.routeToDetails()
        }
    }

}

//MARK: Methods of UITextFieldDelegate

extension SearcherViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        filterTypeViewHandler?.beginTypingHideFilterView()
        hideKeyboard()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        filterTypeViewHandler?.beginTypingHideFilterView()
    }
}

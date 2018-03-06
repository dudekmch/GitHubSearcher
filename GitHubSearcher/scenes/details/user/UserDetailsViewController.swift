import UIKit

protocol UserDetailsDisplayLogic: class {
    func displayUserDetails(viewModel: UserDetails.Data.ViewModel)
}

class UserDetailsViewController: UIViewController, UserDetailsDisplayLogic {
    var interactor: UserDetailsBusinessLogic?
    var router: (NSObjectProtocol & UserDetailsRoutingLogic & UserDetailsDataPassing)?
    
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
        let interactor = UserDetailsInteractor()
        let presenter = UserDetailsPresenter()
        let router = UserDetailsRouter()
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
        repositoriesTableView.dataSource = self
        repositoriesTableView.delegate = self
        getUserDetails()
    }
    
    // MARK: Do something
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var repositoriesTableView: UITableView!
    
    private func getUserDetails() {
        interactor?.getUser()
    }
    
    func displayUserDetails(viewModel: UserDetails.Data.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}

extension UserDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        return UITableViewCell()
    }
    
    
}

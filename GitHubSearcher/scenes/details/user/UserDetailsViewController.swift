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

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
        self.registerNib(identifire: UserDetailsTableViewCell.identifier, target: detailsTableView)
        getUserDetails()
    }


    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var detailsTableView: UITableView!

    var user: User?
    var userUrlDict: [String : URL]?

    private func getUserDetails() {
        interactor?.getUser()
    }

    func displayUserDetails(viewModel: UserDetails.Data.ViewModel) {
        self.user = viewModel.user
        prepareUserDetails()
        userUrlDict = prepareUserUrlDictionary()
        detailsTableView.reloadData()
    }

    private func prepareUserDetails() {
        guard let user = self.user else { return }
        avatarImageView.image = resizeAvatar(image: user.avatarImage)
        login.text = user.login
        scoreLabel.text = user.score.formatDoubleToString(toPlaceRounded: 1)
    }
    
    private func prepareUserUrlDictionary() -> [String : URL]?{
        guard let user = self.user else { return nil }
        var initialDict = [String : URL]()
        initialDict["User"] = user.userURL
        initialDict["Repositories"] = user.repositoriesURL
        initialDict["Followers"] = user.followersURL
        initialDict["Subscriptions"] = user.subscriptionsURL
        initialDict["Organizations"] = user.organizationsURL
        return initialDict
    }

    private func resizeAvatar(image: UIImage?) -> UIImage? {
        guard let image = image else { return nil }
        let rect = CGRect.init(x: 0, y: 0, width: 250, height: 250)
        let size = CGSize.init(width: 250, height: 250)
        return image.resizeImage(rect: rect, size: size)
    }

}

extension UserDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dict = self.userUrlDict else { return 0 }
        return dict.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailsTableViewCell.identifier) as! UserDetailsTableViewCell
        return UITableViewCell()
    }


}

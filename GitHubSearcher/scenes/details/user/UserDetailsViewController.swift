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
        repositoriesTableView.dataSource = self
        repositoriesTableView.delegate = self
        getUserDetails()
    }


    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var repositoriesTableView: UITableView!

    var user: User?

    private func getUserDetails() {
        interactor?.getUser()
    }

    func displayUserDetails(viewModel: UserDetails.Data.ViewModel) {
        self.user = viewModel.user
        prepareUserDetails()
    }

    private func prepareUserDetails() {
        guard let user = self.user else { return }
        avatarImageView.image = resizeAvatar(image: user.avatarImage)
        login.text = user.login
        scoreLabel.text = user.score.formatDoubleToString(toPlaceRounded: 1)
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
        return 15
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }


}

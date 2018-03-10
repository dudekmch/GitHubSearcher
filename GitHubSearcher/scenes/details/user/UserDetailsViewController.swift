import UIKit

protocol UserDetailsDisplayLogic: class {
    func displayUserDetails(viewModel: UserDetails.UserWithFollowersAndRepositories.ViewModel)
    func displayAvatar(viewModel: UserDetails.UserWithAvatar.ViewModel)
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
        getUserDetails()
    }

    @IBOutlet weak var loginTitleLabel: UILabel!
    @IBOutlet weak var scoreTitleLabel: UILabel!
    @IBOutlet weak var goGitHubButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var followersTitleLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var starsTitleLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!


    var user: User?
    var repositoriesStarsSum: Int?

    private let dataNotAvailable = "N/A"

    private func getUserDetails() {
        interactor?.getUser()
    }

    func displayUserDetails(viewModel: UserDetails.UserWithFollowersAndRepositories.ViewModel) {
        self.user = viewModel.user
        self.repositoriesStarsSum = viewModel.stars
         prepareUserDetails()
         downloadAvatarFor(user: user)
    }
    
    func displayAvatar(viewModel: UserDetails.UserWithAvatar.ViewModel){
        guard let user = viewModel.userWithAvatar else { return }
        prepareAvatar(for: user)
    }
    
    private func downloadAvatarFor(user: User?){
        let request = UserDetails.UserWithAvatar.Request.init(user: user)
        interactor?.downloadAvatar(request: request)
    }

    private func prepareUserDetails() {
        guard let user = self.user else { return }
        prepareLabels(for: user)
        prepareGoGitHubButton(for: user)
        prepareFollowersLabels(for: user)
        prepareStarsCount()
    }

    private func prepareAvatar(for user: User) {
        avatarImageView.image = resizeAvatar(image: user.avatarImage)
        avatarImageView.addShadow(to: .left)
    }

    private func prepareGoGitHubButton(for user: User) {
        goGitHubButton.setTitle("Check on GitHub", for: UIControlState.normal)
        goGitHubButton.roundCorners()
        goGitHubButton.addShadow(to: .left)
        goGitHubButton.addTarget(self, action: #selector(goToURL(_:)), for: UIControlEvents.touchUpInside)
    }

    private func prepareLabels(for user: User) {
        loginTitleLabel.text = "Login"
        loginLabel.text = user.login
        scoreTitleLabel.text = "Score"
        if let score = user.score {
            scoreLabel.text = score.formatDoubleToString(toPlaceRounded: 1)
        } else {
            scoreLabel.text = dataNotAvailable
        }
    }

    private func prepareFollowersLabels(for user: User) {
        followersTitleLabel.text = "Followers"
        if let followersCount = user.followers {
            followersLabel.text = String(followersCount)
        } else {
            followersLabel.text = dataNotAvailable
        }
    }

    private func prepareStarsCount() {
        starsTitleLabel.text = "Stars"
        if let stars = repositoriesStarsSum {
            starsLabel.text = String(stars)
        } else {
            starsLabel.text = dataNotAvailable
        }
    }

    private func resizeAvatar(image: UIImage?) -> UIImage? {
        guard let image = image else { return nil }
        let rect = CGRect.init(x: 0, y: 0, width: 250, height: 250)
        let size = CGSize.init(width: 250, height: 250)
        return image.resizeImage(rect: rect, size: size)
    }

    @objc private func goToURL(_ button: UIButton) {
        guard let url = user?.userHTMLURL else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}

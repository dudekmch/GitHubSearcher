import UIKit

protocol RepositoryDetailsDisplayLogic: class {
    func displayRepository(viewModel: RepositoryDetails.Data.ViewModel)
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


    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        getRepositoryDetails()
    }

    var repository: Repository?

    private let dataNotAvailable = "N/A"

    @IBOutlet weak var repositoryNameTitleLabel: UILabel!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var scoreTitleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var createdTitleLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var updatedTitleLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var languageTitleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var ownerTitleLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var descritpionLabel: UILabel!
    @IBOutlet weak var goToGithubButton: UIButton!

    private func getRepositoryDetails() {
        interactor?.getRepository()
    }

    func displayRepository(viewModel: RepositoryDetails.Data.ViewModel) {
        repository = viewModel.repository
        prepareDetails()
    }

    private func prepareDetails() {
        guard let repository = repository else { return }
        prepareNameLabels(for: repository)
        prepareScoreLabels(for: repository)
        prepareCreatedLabels(for: repository)
        prepareUpdatedLabels(for: repository)
        prepareLanguageLabels(for: repository)
        prepareOwnerLabels(for: repository)
        prepareDescriptionLabels(for: repository)
        prepareGoToGithubButton(for: repository)
    }

    private func prepareNameLabels(for repo: Repository) {
        repositoryNameTitleLabel.text = "Repository Name"
        repositoryNameLabel.text = repo.name
    }

    private func prepareScoreLabels(for repo: Repository) {
        scoreTitleLabel.text = "Score"
        if let score = repo.score {
            scoreLabel.text = score.formatDoubleToString(toPlaceRounded: 1)
        } else {
            scoreLabel.text = dataNotAvailable
        }
        
    }

    private func prepareCreatedLabels(for repo: Repository) {
        createdTitleLabel.text = "Created"
        createdLabel.text = repo.created.formatToString()
    }

    private func prepareUpdatedLabels(for repo: Repository) {
        updatedTitleLabel.text = "Updated"
        updateLabel.text = repo.updated.formatToString()
    }

    private func prepareLanguageLabels(for repo: Repository) {
        languageTitleLabel.text = "Language"
        if let language = repo.language {
            languageLabel.text = language
        } else {
            languageLabel.text = dataNotAvailable
        }
    }

    private func prepareOwnerLabels(for repo: Repository) {
        ownerTitleLabel.text = "Owner"
        ownerLabel.text = repo.owner
    }

    private func prepareDescriptionLabels(for repo: Repository) {
        descriptionTitleLabel.text = "Description"
        descritpionLabel.textAlignment = .center
        if let description = repo.description {
            descritpionLabel.text = description
        } else {
            descritpionLabel.text = dataNotAvailable
        }
    }

    private func prepareGoToGithubButton(for repo: Repository) {
        goToGithubButton.setTitle("Check on GitHub", for: UIControlState.normal)
        goToGithubButton.roundCorners()
        goToGithubButton.addShadow(to: .left)
        goToGithubButton.addTarget(self, action: #selector(goToURL(_:)), for: UIControlEvents.touchUpInside)
    }

    @objc private func goToURL(_ button: UIButton) {
        guard let url = repository?.repositoryURL else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}



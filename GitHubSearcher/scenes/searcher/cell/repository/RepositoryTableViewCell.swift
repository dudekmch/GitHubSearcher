import UIKit

class RepositoryTableViewCell: UITableViewCell {

    static let identifier = "RepositoryTableViewCell"
    private static let dataNotAvaliable = "N/A"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(name: String, score: String, description: String?, userName: String?) {
        nameLabel.text = name
        scoreLabel.text = "score: \(score)"
        if let description = description {
            descriptionLabel.text = description
        } else {
            descriptionLabel.text = RepositoryTableViewCell.dataNotAvaliable
        }
        if let userName = userName {
            userNameLabel.text = userName
        } else {
            userNameLabel.text = RepositoryTableViewCell.dataNotAvaliable
        }
    }
}

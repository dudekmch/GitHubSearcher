import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let identifier = "UserTableViewCell"
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(avatar: UIImage, login: String, score: String){
        self.contentView.contentMode = .scaleAspectFit
        self.avatarImageView.image = avatar
        self.loginLabel.text = login
        self.scoreLabel.text = "score: \(score)"
    }
    
}

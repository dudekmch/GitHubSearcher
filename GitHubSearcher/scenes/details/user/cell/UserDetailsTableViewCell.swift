import UIKit

class UserDetailsTableViewCell: UITableViewCell {

    static let identifier = "UserDetailsTableViewCell"
    
    var urlName: String?
    var url: URL?
    
    @IBOutlet weak var urlNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if UIApplication.shared.canOpenURL(url!) {
            print(url!)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }}
    
    func setUserDetailsCell(urlName: String?, url: URL?){
        self.urlName = urlName
        self.url = url
        urlNameLabel.text = urlName
    }
}

import Foundation
import UIKit

extension UIViewController {
    
    func registerNib(identifire: String,target view: UITableView) {
        let nib = UINib(nibName: identifire, bundle: nil)
        view.register(nib, forCellReuseIdentifier: identifire)
    }
}

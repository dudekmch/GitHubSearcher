import Foundation
import UIKit

protocol FilterTypeDisplayingLogic {
    func filterTypeViewHandler(of view: UIView)
}

class FilterTypeViewHandler: FilterTypeDisplayingLogic {
    var isFilterTypeViewDisplayed: Bool = false

    func filterTypeViewHandler(of view: UIView) {
        if isFilterTypeViewDisplayed {
            self.hide(view: view)
            isFilterTypeViewDisplayed = false
        } else {
            self.show(view: view)
            isFilterTypeViewDisplayed = true
        }
    }

    private func hide(view: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 0
        }, completion: {
                (value: Bool) in
                view.isHidden = true
            })
    }

    private func show(view: UIView) {
        view.alpha = 0
        view.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 1
        }, completion: nil)
    }


}

import Foundation
import UIKit

protocol FilterTypeDisplayingLogic {
    func filterTypeViewHandler(of view: UIView)
}

protocol FilterTypeButtonsLogic {
    func usersFilterTypeButtonSelected(_ usersFilterButton: UIButton, _ repositoriesFilterButton: UIButton, in filterView: UIView)
    func repositoriesFilterTypeButtonSelected(_ usersFilterButton: UIButton, _ repositoriesFilterButton: UIButton, in filterView: UIView)
    func configureDefaultFilterTypeButtonProperties(_ usersFilterButton: UIButton, _ repositoriesFilterButton: UIButton)
}

protocol FilterTypeValue {
    var currentFilterType: FilterType { get }
}

class FilterTypeViewHandler: FilterTypeDisplayingLogic, FilterTypeButtonsLogic, FilterTypeValue {

    var currentFilterType: FilterType = .users

    private var isFilterTypeViewDisplayed: Bool = false

    func configureDefaultFilterTypeButtonProperties(_ usersFilterButton: UIButton, _ repositoriesFilterButton: UIButton) {
        usersFilterButton.backgroundColor = .green
        usersFilterButton.setTitle("Users", for: UIControlState.normal)
        repositoriesFilterButton.backgroundColor = .blue
        repositoriesFilterButton.setTitle("Repositories", for: UIControlState.normal)
    }

    func usersFilterTypeButtonSelected(_ usersFilterButton: UIButton, _ repositoriesFilterButton: UIButton, in filterView: UIView) {
        currentFilterType = .users
        usersFilterButton.backgroundColor = .green
        repositoriesFilterButton.backgroundColor = .blue
        filterTypeViewHandler(of: filterView)
    }

    func repositoriesFilterTypeButtonSelected(_ usersFilterButton: UIButton, _ repositoriesFilterButton: UIButton, in filterView: UIView) {
        currentFilterType = .repositories
        usersFilterButton.backgroundColor = .blue
        repositoriesFilterButton.backgroundColor = .green
        filterTypeViewHandler(of: filterView)
    }

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

import Foundation
import UIKit

protocol FilterTypeDisplayingLogic {
    func filterTypeViewHandler(of view: UIView)
    func beginTypingHide(view: UIView)
}

protocol FilterTypeButtonsLogic {
    func usersFilterTypeButtonSelected(_ usersFilterButton: UIButton, _ repositoriesFilterButton: UIButton, in filterView: UIView)
    func repositoriesFilterTypeButtonSelected(_ usersFilterButton: UIButton, _ repositoriesFilterButton: UIButton, in filterView: UIView)
}

protocol FilterTypeButtonConfigurator {
    func configureDefaultFilterTypeButtonsProperties(_ usersFilterButton: UIButton, _ repositoriesFilterButton: UIButton)
    func configureShowFilterTypeViewButton(_ button: UIButton)
}

protocol FilterTypeValue {
    var currentFilterType: FilterType { get }
}

class FilterTypeViewHandler: FilterTypeDisplayingLogic, FilterTypeButtonsLogic, FilterTypeValue, FilterTypeButtonConfigurator {

    var currentFilterType: FilterType = .users

    private var isFilterTypeViewDisplayed: Bool = false

    func configureShowFilterTypeViewButton(_ button: UIButton) {
        button.setTitle("Filter", for: UIControlState.normal)
        button.roundCorners()
    }

    func configureDefaultFilterTypeButtonsProperties(_ usersFilterButton: UIButton, _ repositoriesFilterButton: UIButton) {
        usersFilterButton.backgroundColor = .green
        usersFilterButton.setTitle("Users", for: UIControlState.normal)
        usersFilterButton.roundCorners()
        repositoriesFilterButton.backgroundColor = .blue
        repositoriesFilterButton.setTitle("Repositories", for: UIControlState.normal)
        repositoriesFilterButton.roundCorners()
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

    func beginTypingHide(view: UIView) {
        if isFilterTypeViewDisplayed {
            hide(view: view)
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

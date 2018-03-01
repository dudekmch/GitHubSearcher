import Foundation
import UIKit

protocol FilterTypeDisplayingLogic {
    func filterTypeViewHandler()
    func beginTypingHideView()
}

protocol FilterTypeButtonsLogic {
    func usersFilterTypeButtonSelected()
    func repositoriesFilterTypeButtonSelected()
}

protocol FilterTypeButtonConfigurator {
    func configureDefaultFilterTypeButtonsProperties()
    func configureShowFilterTypeViewButton()
}

protocol FilterTypeValue {
    var currentFilterType: FilterType { get }
}

class FilterTypeViewHandler: FilterTypeDisplayingLogic, FilterTypeButtonsLogic, FilterTypeValue, FilterTypeButtonConfigurator {

    //.user is start value
    var currentFilterType: FilterType = .users

    private var isFilterTypeViewDisplayed: Bool = false

    init(of controller: FilterTypeViewElements) {
        self.filterTypeViewElements = controller
    }

    let filterTypeViewElements: FilterTypeViewElements

    func configureShowFilterTypeViewButton() {
        filterTypeViewElements.showFilterTypeViewButton.setTitle("Filter", for: UIControlState.normal)
        filterTypeViewElements.showFilterTypeViewButton.roundCorners()
    }

    func configureDefaultFilterTypeButtonsProperties() {
        setupSetUserFilterTypeButton()
        setupSetRepositoryFilterTypeButton()
    }

    func usersFilterTypeButtonSelected() {
        currentFilterType = .users
        filterTypeViewElements.setUserFilterTypeButton.backgroundColor = .green
        filterTypeViewElements.setRepositoryFilterTypeButton.backgroundColor = .blue
        filterTypeViewHandler()
    }

    func repositoriesFilterTypeButtonSelected() {
        currentFilterType = .repositories
        filterTypeViewElements.setUserFilterTypeButton.backgroundColor = .blue
        filterTypeViewElements.setRepositoryFilterTypeButton.backgroundColor = .green
        filterTypeViewHandler()
    }

    func filterTypeViewHandler() {
        if isFilterTypeViewDisplayed {
            self.hideView()
            isFilterTypeViewDisplayed = false
        } else {
            self.showView()
            isFilterTypeViewDisplayed = true
        }
    }

    func beginTypingHideView() {
        if isFilterTypeViewDisplayed {
            self.hideView()
        }
    }

    private func hideView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.filterTypeViewElements.filterTypeView.alpha = 0
        }, completion: {
                (value: Bool) in
                self.filterTypeViewElements.filterTypeView.isHidden = true
            })
    }

    private func showView() {
        filterTypeViewElements.filterTypeView.alpha = 0
        filterTypeViewElements.filterTypeView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.filterTypeViewElements.filterTypeView.alpha = 1
        }, completion: nil)
    }

    private func setupSetUserFilterTypeButton() {
        filterTypeViewElements.setUserFilterTypeButton.backgroundColor = .green
        filterTypeViewElements.setUserFilterTypeButton.setTitle("Users", for: UIControlState.normal)
        filterTypeViewElements.setUserFilterTypeButton.roundCorners()
    }

    private func setupSetRepositoryFilterTypeButton() {
        filterTypeViewElements.setRepositoryFilterTypeButton.backgroundColor = .blue
        filterTypeViewElements.setRepositoryFilterTypeButton.setTitle("Repositories", for: UIControlState.normal)
        filterTypeViewElements.setRepositoryFilterTypeButton.roundCorners()
    }


}

import Foundation
import UIKit

protocol FilterTypeDisplayingLogic {
    func filterTypeViewHandler()
    func beginTypingHideFilterView()
}

protocol FilterTypeButtonsLogic {
    func usersFilterTypeButtonSelected()
    func repositoriesFilterTypeButtonSelected()
}

protocol FilterTypeButtonConfigurator {
    func configureDefaultFilterTypeButtonsProperties()
    func configureShowFilterTypeViewButton()
    func setupSortButton()
}

protocol FilterTypeValue {
    var currentFilterType: FilterType { get }
}

class FilterTypeViewHandler: FilterTypeDisplayingLogic, FilterTypeButtonsLogic, FilterTypeValue, FilterTypeButtonConfigurator {

    //.user is start value
    var currentFilterType: FilterType = .users

    private var isFilterTypeViewDisplayed: Bool = false

    init(of controller: FilterTypeViewUIElements) {
        self.filterTypeViewElements = controller
    }

    private let filterTypeViewElements: FilterTypeViewUIElements


    func configureShowFilterTypeViewButton() {
        filterTypeViewElements.showFilterTypeViewButton.setTitle("Filters", for: UIControlState.normal)
        filterTypeViewElements.showFilterTypeViewButton.roundCorners()
        filterTypeViewElements.showFilterTypeViewButton.backgroundColor = .lightGray
    }

    func configureDefaultFilterTypeButtonsProperties() {
        setupSetUserFilterTypeButton()
        setupSetRepositoryFilterTypeButton()
    }

    func usersFilterTypeButtonSelected() {
        currentFilterType = .users
        filterTypeViewElements.setUserFilterTypeButton.backgroundColor = .green
        filterTypeViewElements.setRepositoryFilterTypeButton.backgroundColor = .lightGray
        filterTypeViewHandler()
    }

    func repositoriesFilterTypeButtonSelected() {
        currentFilterType = .repositories
        filterTypeViewElements.setUserFilterTypeButton.backgroundColor = .lightGray
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

    func beginTypingHideFilterView() {
        if isFilterTypeViewDisplayed {
            isFilterTypeViewDisplayed = false
            self.hideView()
        }
    }
    
    func setupSortButton() {
        filterTypeViewElements.sortButton.setTitle(" Sort by ID ", for: UIControlState.normal)
        filterTypeViewElements.sortButton.backgroundColor = .lightGray
        filterTypeViewElements.sortButton.roundCorners()
    }


    private func hideView() {
        let view = filterTypeViewElements.filterTypeView!
        UIView.animate(withDuration: 0.5, animations: {
            view.center.y += view.frame.height
        }, completion: { value in
                self.filterTypeViewElements.filterTypeView.isHidden = true
                view.center.y -= view.frame.height
            })
    }

    private func showView() {
        filterTypeViewElements.filterTypeView.isHidden = false
        let view = filterTypeViewElements.filterTypeView!
        view.center.y += view.frame.height
        UIView.animate(withDuration: 0.3, animations: {
            view.center.y -= view.frame.height
        })
    }

    private func setupSetUserFilterTypeButton() {
        filterTypeViewElements.setUserFilterTypeButton.backgroundColor = .green
        filterTypeViewElements.setUserFilterTypeButton.setTitle("Users", for: UIControlState.normal)
        filterTypeViewElements.setUserFilterTypeButton.roundCorners()
    }

    private func setupSetRepositoryFilterTypeButton() {
        filterTypeViewElements.setRepositoryFilterTypeButton.backgroundColor = .lightGray
        filterTypeViewElements.setRepositoryFilterTypeButton.setTitle("Repositories", for: UIControlState.normal)
        filterTypeViewElements.setRepositoryFilterTypeButton.roundCorners()
    }

}

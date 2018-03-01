import Foundation
import UIKit

protocol DataTableViewProvider {
    func getDataListCount(for currentFilterType: FilterType?) -> Int
    func prepareCellWithData(for currentFilterType: FilterType?, with indexPath: IndexPath) -> UITableViewCell
}

class DataTableViewHandler: DataTableViewProvider {

    init(of controller: SearchViewData) {
        self.controller = controller
    }
    
    private let controller: SearchViewData

    func getDataListCount(for currentFilterType: FilterType?) -> Int {
        guard
            let currentFilter = currentFilterType else { return 0 }
        switch currentFilter {
        case .users:
            guard let userList = controller.userList else { return 0 }
            return userList.count
        case .repositories:
            guard let repositoryList = controller.repositoryList else { return 0 }
            return repositoryList.count
        }
    }

    func prepareCellWithData(for currentFilterType: FilterType?, with indexPath: IndexPath) -> UITableViewCell {
        guard
            let currentFilter = currentFilterType else { return UITableViewCell() }
        switch currentFilter {
        case .users:
            guard let userList = controller.userList else { return UITableViewCell() }
            let cell = UserTableViewCell()
            cell.textLabel?.text = "\(userList[indexPath.row].id) \(userList[indexPath.row].login)"
            return cell
        case .repositories:
            guard let repositoryList = controller.repositoryList else { return UITableViewCell() }
            let cell = RepositoryTableViewCell()
            cell.textLabel?.text = "\(repositoryList[indexPath.row].id) \(repositoryList[indexPath.row].name)"
            return cell
        }
    }
}

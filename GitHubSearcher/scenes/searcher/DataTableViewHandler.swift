import Foundation
import UIKit

protocol DataTableViewProvider {
    func getDataListCount(for currentFilterType: FilterType?) -> Int
    func prepareCellWithData(for currentFilterType: FilterType?, with indexPath: IndexPath, register tableView: UITableView) -> UITableViewCell
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

    func prepareCellWithData(for currentFilterType: FilterType?, with indexPath: IndexPath, register tableView: UITableView) -> UITableViewCell {
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
            
            return createRepositoryCell(with: indexPath.row, from: repositoryList, for: tableView)
        }
    }

    private func createRepositoryCell(with indexPathRow: Int, from list: [Repository], for tableView: UITableView) -> RepositoryTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.identifier) as! RepositoryTableViewCell
        let repository = list[indexPathRow]
        cell.setData(name: repository.name, score: repository.score.rounded(), description: repository.description, userName: repository.owner)
        return cell
    }
}

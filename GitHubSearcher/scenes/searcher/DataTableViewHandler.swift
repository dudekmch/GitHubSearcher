import Foundation
import UIKit

protocol DataTableViewProvider {
    func getDataListCount(for currentFilterType: FilterType?) -> Int
    func prepareCellWithData(for currentFilterType: FilterType?, with indexPath: IndexPath, register tableView: UITableView) -> UITableViewCell
    func sortData(for currentFilterType: FilterType?)
}

class DataTableViewHandler: DataTableViewProvider {

    init(of controller: SearchViewData) {
        self.controller = controller
    }

    private let dataNotAvailable = "N/A"

    private var controller: SearchViewData

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
            return createUserCell(with: indexPath.row, from: userList, for: tableView)
        case .repositories:
            guard let repositoryList = controller.repositoryList else { return UITableViewCell() }

            return createRepositoryCell(with: indexPath.row, from: repositoryList, for: tableView)
        }
    }

    func sortData(for currentFilterType: FilterType?) {
        guard let currentFilter = currentFilterType else { return }
        switch currentFilter {
        case .users:
            guard let data = controller.userList else { return }
            controller.userList = data.sorted { $0.id < $1.id }
        case .repositories:
            guard let data = controller.repositoryList else { return }
            controller.repositoryList = data.sorted { $0.id < $1.id }
        }
    }

    private func createRepositoryCell(with indexPathRow: Int, from list: [Repository], for tableView: UITableView) -> RepositoryTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.identifier) as! RepositoryTableViewCell
        let repository = list[indexPathRow]
        if let score = repository.score {
            let formattedScore = score.formatDoubleToString(toPlaceRounded: 1)
            cell.setData(name: repository.name, score: formattedScore, description: repository.description, userName: repository.owner)
        } else {
            cell.setData(name: repository.name, score: dataNotAvailable, description: repository.description, userName: repository.owner)

        }
        return cell
    }

    private func createUserCell(with indexPathRow: Int, from list: [User], for tableView: UITableView) -> UserTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier) as! UserTableViewCell
        let user = list[indexPathRow]
        if let score = user.score {
            let formattedScore = score.formatDoubleToString(toPlaceRounded: 1)
            cell.setData(avatar: prepareAvatarFrom(image: user.avatarImage), login: String(indexPathRow), score: formattedScore)
        } else {
            cell.setData(avatar: prepareAvatarFrom(image: user.avatarImage), login: user.login, score: dataNotAvailable)
        }

        return cell
    }

    private func prepareAvatarFrom(image: UIImage?) -> UIImage {
        guard let imageToResize = image else { return #imageLiteral(resourceName: "na-avatar") }
        if let resizedImage = resize(image: imageToResize) {
            return resizedImage
        }
        return #imageLiteral(resourceName: "na-avatar")
    }

    private func resize(image: UIImage) -> UIImage? {
        let rect = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        let size = CGSize.init(width: 40, height: 40)
        return image.resizeImage(rect: rect, size: size)
    }

}

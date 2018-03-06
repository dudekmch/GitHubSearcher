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
            return createUserCell(with: indexPath.row, from: userList, for: tableView)
        case .repositories:
            guard let repositoryList = controller.repositoryList else { return UITableViewCell() }

            return createRepositoryCell(with: indexPath.row, from: repositoryList, for: tableView)
        }
    }

    private func createRepositoryCell(with indexPathRow: Int, from list: [Repository], for tableView: UITableView) -> RepositoryTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.identifier) as! RepositoryTableViewCell
        let repository = list[indexPathRow]
        cell.setData(name: String(repository.id), score: String(indexPathRow), description: repository.description, userName: repository.owner)
        return cell
    }

    private func createUserCell(with indexPathRow: Int, from list: [User], for tableView: UITableView) -> UserTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier) as! UserTableViewCell
        let user = list[indexPathRow]
        cell.setData(avatar: prepareAvatarFrom(image: user.avatarImage), login: String(user.id), score: String(indexPathRow))
        return cell
    }

    private func formatScore(score: Double) -> String {
        let score = String(score.rounded(toPlaces: 1))
        return score
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

import Alamofire
import AlamofireImage

class ImageDownloadService {

    static let shared = ImageDownloadService()

    private init() { }

    func getImagae(for users: [User], result: @escaping (User) -> Void) {
        for user in users {
            guard let avatarUrl = user.avatarURL else { return }
            Alamofire.request(avatarUrl).responseImage { apiResponse in
                switch apiResponse.result {
                case .success:
                    if let avatar = apiResponse.result.value {
                        user.avatarImage = avatar
                        result(user)
                    }
                case .failure:
                    result(user)
                }
            }
        }
    }
}


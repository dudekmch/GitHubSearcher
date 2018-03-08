import Foundation
import UIKit

class User: ResponseModel {

    let login: String
    let id: Int
    let score: Double?

    let avatarURL: URL?
    let userHTMLURL: URL
    let userApiURL: URL
    let followersURL: URL
    let subscriptionsURL: URL
    let organizationsURL: URL
    let repositoriesURL: URL
    var followers: Int?
    var avatarImage: UIImage?



    init(login: String, id: Int, score: Double?, avatarURL: String?, userHTMLURL: String, followersURL: String, subscriptionsURL: String, organizationsURL: String, repositoriesURL: String, userApiURL: String, followers: Int?) {
        self.login = login
        self.id = id
        self.score = score

        if let avatarURL = avatarURL {
            self.avatarURL = URL.init(string: avatarURL)
        } else {
            self.avatarURL = nil
        }

        self.userHTMLURL = URL.init(string: userHTMLURL)!
        self.followersURL = URL.init(string: followersURL)!
        self.subscriptionsURL = URL.init(string: subscriptionsURL)!
        self.organizationsURL = URL.init(string: organizationsURL)!
        self.repositoriesURL = URL.init(string: repositoriesURL)!
        self.userApiURL = URL.init(string: userApiURL)!
        self.followers = followers
    }

    required convenience init?(json: JSON) {
        guard
            let login = json["login"] as? String,
            let id = json["id"] as? Int,
            let userHTMLURL = json["html_url"] as? String,
            let followersURL = json["followers_url"] as? String,
            let subscriptionsURL = json["subscriptions_url"] as? String,
            let organizationsURL = json["organizations_url"] as? String,
            let repositoriesURL = json["repos_url"] as? String,
            let userApiURL = json["url"] as? String

            else { return nil }
        let avatarURL = json["avatar_url"] as? String
        let score = json["score"] as? Double
        let followers = json["followers"] as? Int
        
        self.init(login: login, id: id, score: score, avatarURL: avatarURL, userHTMLURL: userHTMLURL, followersURL: followersURL, subscriptionsURL: subscriptionsURL, organizationsURL: organizationsURL, repositoriesURL: repositoriesURL, userApiURL: userApiURL, followers: followers)
    }

}

import Foundation

class User {
    
    let login: String
    let id: Int
    let score: Double
    
    let avatarURL: URL?
    let userURL: URL
    let followersURL: URL
    let subscriptionsURL: URL
    let organizationsURL: URL
    let repositoriesURL: URL
    
    init(login: String, id: Int, score: Double, avatarURL: String?, userURL: String, followersURL: String, subscriptionsURL: String, organizationsURL: String, repositoriesURL: String) {
        self.login = login
        self.id = id
        self.score = score
        if let avatar = avatarURL {
            self.avatarURL =  URL.init(string: avatar)
        } else {
            self.avatarURL = nil
        }
        self.userURL = URL.init(string: userURL)!
        self.followersURL = URL.init(string: followersURL)!
        self.subscriptionsURL = URL.init(string: subscriptionsURL)!
        self.organizationsURL = URL.init(string: organizationsURL)!
        self.repositoriesURL = URL.init(string: repositoriesURL)!
    }
    
    convenience init?(json: JSON) {
        guard
            let login = json["login"] as? String,
            let id = json["id"] as? Int,
            let score = json["score"] as? Double,
            let avatarURL = json["avatar_url"] as? String,
            let userURL = json["html_url"] as? String,
            let followersURL = json["followers_url"] as? String,
            let subscriptionsURL = json["subscriptions_url"] as? String,
            let organizationsURL = json["organizations_url"] as? String,
            let repositoriesURL = json["repos_url"] as? String

        else { return nil }

        self.init(login: login, id: id, score: score, avatarURL: avatarURL, userURL: userURL, followersURL: followersURL, subscriptionsURL: subscriptionsURL, organizationsURL: organizationsURL, repositoriesURL: repositoriesURL)
    }

}

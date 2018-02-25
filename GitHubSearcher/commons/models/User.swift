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
    
    init(login: String, id: Int, score: Double, avatarURL: URL?, userURL: URL, followersURL: URL, subscriptionsURL: URL, organizationsURL: URL, repositoriesURL: URL) {
        self.login = login
        self.id = id
        self.score = score
        self.avatarURL = avatarURL
        self.userURL = userURL
        self.followersURL = followersURL
        self.subscriptionsURL = subscriptionsURL
        self.organizationsURL = organizationsURL
        self.repositoriesURL = repositoriesURL
    }
    
    init?(json: JSON) {
        guard
            let login = json["login"] as? String,
            let id = json["id"] as? Int,
            let score = json["score"] as? Double,
            let avatarURL = json["avatar_url"] as? URL?,
            let userURL = json["html_url"] as? URL,
            let followersURL = json["followers_url"] as? URL,
            let subscriptionsURL = json["subscriptions_url"] as? URL,
            let organizationsURL = json["organizations_url"] as? URL,
            let repositoriesURL = json["repos_url"] as? URL

        else { return nil }
        
                self.login = login
                self.id = id
                self.score = score
                self.avatarURL = avatarURL
                self.userURL = userURL
                self.followersURL = followersURL
                self.subscriptionsURL = subscriptionsURL
                self.organizationsURL = organizationsURL
                self.repositoriesURL = repositoriesURL
    }

}

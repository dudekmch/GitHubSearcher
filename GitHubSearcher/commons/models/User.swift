import Foundation

class User {
    
    let login: String
    let id: Int
    let score: Double
    
    let avatarURL: URL?
    let userURL: URL?
    let followersURL: URL?
    let subscriptionsURL: URL?
    let organizationsURL: URL?
    let repositoriesURL: URL?
    
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
            let avatarURL = json["avatar_url"] as? String,
            let userURL = json["html_url"] as? String,
            let followersURL = json["followers_url"] as? String,
            let subscriptionsURL = json["subscriptions_url"] as? String,
            let organizationsURL = json["organizations_url"] as? String,
            let repositoriesURL = json["repos_url"] as? String

        else { return nil }
        
                self.login = login
                self.id = id
                self.score = score
                self.avatarURL = URL.init(string: avatarURL as String)
                self.userURL =  URL.init(string: userURL as String)
                self.followersURL =  URL.init(string: followersURL as String)
                self.subscriptionsURL =  URL.init(string: subscriptionsURL as String)
                self.organizationsURL =  URL.init(string: organizationsURL as String)
                self.repositoriesURL =  URL.init(string: repositoriesURL as String)
    }

}

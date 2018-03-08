import UIKit

enum UserDetails {
    
    static func getFollowersCount(from json: JSON) -> Int?{
        guard let followers = json["followers"] else { return nil }
        let followersCount: Int = followers as! Int
        return followersCount
    }
    
    static func repositories(from jsonList: [JSON]) -> [Repository]? {
        let modelsJSON: [JSON] = jsonList
        return modelsJSON.flatMap { Repository(json: $0) }
    }

    enum Data {
        struct Request {
        }

        struct Response {
            init(user: User?) {
                self.user = user
            }
            var user: User?
        }

        struct ViewModel {
            init(user: User?) {
                self.user = user
            }
            var user: User?
        }
    }


    enum Followers {
        struct Request {
            init(user: User) {
                self.user = user
            }
            let user: User
        }

        struct Response {
            init(json: JSON, user: User) {
                self.success = true
                self.user = user
                self.user.followers = UserDetails.getFollowersCount(from: json)
            }
            
            var success: Bool
            var user: User
        }

        struct ViewModel {
            init(userWithFollowers: User) {
                self.user = userWithFollowers
            }
            var user: User
        }
    }
    
    enum UserRepositories {
        struct Request {
            let urlRepositories: URL
        }
        
        struct Response {
            
            init(jsonList: [JSON]) {
                self.success = true
                self.models = UserDetails.repositories(from: jsonList)
            }
            
            init() {
                self.success = false
            }
            
            var success: Bool
            var models: [Repository]?
            
        }
        
        struct ViewModel {
            init(allStarsFromRepositories: Int?){
                self.stars = allStarsFromRepositories
            }
            var stars: Int?
        }
    }
}

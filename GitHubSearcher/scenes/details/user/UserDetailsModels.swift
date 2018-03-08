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

    enum Followers {
        struct Request {
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
    
    enum UserWithFollowersAndRepositories {
        struct Request {
        }
        
        struct Response {
            
            init(jsonList: [JSON], user: User?) {
                self.success = true
                self.models = UserDetails.repositories(from: jsonList)
                self.user = user
            }
            
            init() {
                self.success = false
            }
            
            var success: Bool
            var models: [Repository]?
            var user: User?
            
        }
        
        struct ViewModel {
            init(allStarsFromRepositories: Int?, userWithFollowers: User){
                self.stars = allStarsFromRepositories
                self.user = userWithFollowers
            }
            var stars: Int?
            var user: User?
        }
    }
}

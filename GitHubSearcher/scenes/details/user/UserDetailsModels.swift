import UIKit

enum UserDetails {
    
    static func getFollowersCount(from json: JSON) -> Int?{
        guard let followers = json["followers"] else { return nil }
        let followersCount: Int = followers as! Int
        return followersCount
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
}

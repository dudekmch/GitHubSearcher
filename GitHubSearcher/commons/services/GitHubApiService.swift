import Alamofire

typealias JSON = Dictionary<String, Any>

class GitHubApiService {
    
    static let shared = GitHubApiService()
    
    private init(){}
    
    func searchUsers(filter: String, result: @escaping (_ response: Searcher.Users.Response) -> Void){
        Alamofire.request("https://api.github.com/search/users?q=\(filter)&per_page=100")
            .responseJSON { apiResponse in
                switch apiResponse.result {
                case .success:
                    if let json = apiResponse.result.value as? JSON {
                       result(Searcher.Users.Response(json: json))
                    }
                case .failure:
                    result(Searcher.Users.Response())
                }
        }
    }
    
    func searchRepositories(filter: String, result: @escaping (_ response: Searcher.Repositories.Response) -> Void){
        Alamofire.request("https://api.github.com/search/repositories?q=\(filter)&per_page=100")
            .responseJSON { apiResponse in
                switch apiResponse.result {
                case .success:
                    if let json = apiResponse.result.value as? JSON {
                        result(Searcher.Repositories.Response(json: json))
                    }
                case .failure:
                    result(Searcher.Repositories.Response())
                }
        }
    }
}

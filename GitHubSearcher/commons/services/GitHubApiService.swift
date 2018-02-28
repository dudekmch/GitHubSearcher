import Alamofire

typealias JSON = Dictionary<String, Any>

class GitHubApiService {
    
    static let shared = GitHubApiService()
    
    private init(){}
    
    func searchUsers(filter: String, result: @escaping (_ response: Searcher.Data.Response<User>) -> Void){
        Alamofire.request("https://api.github.com/search/users?q=\(filter)&per_page=100")
            .responseJSON { apiResponse in
                switch apiResponse.result {
                case .success:
                    if let json = apiResponse.result.value as? JSON {
                       result(Searcher.Data.Response(json: json))
                    }
                case .failure:
                    result(Searcher.Data.Response())
                }
        }
    }
    
    func searchRepositories(filter: String, result: @escaping (_ response: Searcher.Data.Response<Repository>) -> Void){
        Alamofire.request("https://api.github.com/search/repositories?q=\(filter)&per_page=100")
            .responseJSON { apiResponse in
                switch apiResponse.result {
                case .success:
                    if let json = apiResponse.result.value as? JSON {
                        result(Searcher.Data.Response(json: json))
                    }
                case .failure:
                    result(Searcher.Data.Response())
                }
        }
    }
}

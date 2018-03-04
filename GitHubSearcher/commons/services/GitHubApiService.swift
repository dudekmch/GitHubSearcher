import Alamofire

typealias JSON = Dictionary<String, Any>

class GitHubApiService {

    static let shared = GitHubApiService()

    private init() { }

    func searchUsers(searchTerm: String, result: @escaping (_ response: Searcher.Data.Response<User>) -> Void) {
        Alamofire.request("https://api.github.com/search/users?q=\(searchTerm)&per_page=100")
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

    func searchRepositories(searchTerm: String, result: @escaping (_ response: Searcher.Data.Response<Repository>) -> Void) {
        Alamofire.request("https://api.github.com/search/repositories?q=\(searchTerm)&per_page=100")
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

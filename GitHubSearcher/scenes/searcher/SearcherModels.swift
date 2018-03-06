import UIKit

enum Searcher {

    static func models<T: ResponseModel>(from json: JSON) -> [T]? {
        guard let items = json["items"] else { return nil }
        let modelsJSON: [JSON] = items as! [JSON]
        return modelsJSON.flatMap { T(json: $0) }
    }

    static func countOfPages(from json: JSON) -> Int? {
        guard let totalCount = json["total_count"] else { return nil }
        let totalCountOfResults: Int = totalCount as! Int
        if (totalCountOfResults % 100 == 0) {
            return totalCountOfResults / 100
        } else {
            return (totalCountOfResults / 100) + 1
        }
    }

    enum Data {
        struct Request {
            let searchTerm: String
            let filterType: FilterType
        }

        struct Response<T: ResponseModel> {

            init(json: JSON) {
                self.success = true
                self.models = Searcher.models(from: json)
                self.countOfPages = Searcher.countOfPages(from: json)
            }

            init() {
                self.success = false
            }

            var success: Bool
            var models: [T]?
            var countOfPages: Int?

        }

        struct ViewModel<T: ResponseModel> {
            let dataList: [T]
        }
    }
}



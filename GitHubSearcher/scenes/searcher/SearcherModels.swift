import UIKit

enum Searcher {

    static func models<T: ResponseModel>(from json: JSON) -> [T]? {
        guard let items = json["items"] else { return nil }
        let modelsJSON: [JSON] = items as! [JSON]
        return modelsJSON.flatMap { T(json: $0) }
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
            }

            init() {
                self.success = false
            }
            
            init(data: [T]){
                self.success = true
                self.models = data
            }

            var success: Bool
            var models: [T]?
        }

        struct ViewModel<T: ResponseModel> {
            let dataList: [T]
        }
    }
}



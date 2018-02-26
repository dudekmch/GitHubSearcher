import Foundation

class Repository: ResponseModel {
    
    let privateRepository: Bool
    let repositoryURL: URL
    let description: String?
    let created: Date
    let updated: Date
    let language: String?
    let score: Double
    
    init(privateRepository: Bool, repositoryURL: String, description: String?, created: String, updated: String, language: String?, score: Double){
        self.privateRepository = privateRepository
        self.repositoryURL = URL.init(string: repositoryURL)!
        self.description = description
        self.created = Formatter.iso8601.date(from: created)!
        self.updated = Formatter.iso8601.date(from: updated)!
        self.language = language
        self.score = score
    }
    
    convenience required init?(json: JSON){
        guard
            let privateRepository = json["private"] as? Bool,
            let repositoryURL = json["html_url"] as? String,
            let created = json["created_at"] as? String,
            let updated = json["updated_at"] as? String,
            let score = json["score"] as? Double
        
            else { return nil }
        
        let description = json["description"] as? String
        let language = json["language"] as? String
        
        self.init(privateRepository: privateRepository, repositoryURL: repositoryURL, description: description, created: created, updated: updated, language: language, score: score)
    }
  
}

import Foundation

class Repository {
    
    let privateRepository: Bool
    let repositoryURL: URL
    let description: String
    let created: Date?
    let updated: Date?
    let size: Int
    let language: String?
    let score: Double
    
    init(privateRepository: Bool, repositoryURL: URL, description: String, created: Date?, updated: Date?, size: Int, language: String?, score: Double){
        self.privateRepository = privateRepository
        self.repositoryURL = repositoryURL
        self.description = description
        self.created = created
        self.updated = updated
        self.size = size
        self.language = language
        self.score = score
    }
    
    init?(json: JSON){
        guard
            let privateRepository = json["private"] as? Bool,
            let repositoryURL = json["html_url"] as? URL,
            let description = json["description"] as? String,
            let created = json["created_at"] as? String,
            let updated = json["updated_at"] as? String,
            let size = json["updated_at"] as? Int,
            let language = json["language"] as? String,
            let score = json["score"] as? Double
        
            else { return nil }
        
            self.privateRepository = privateRepository
            self.repositoryURL = repositoryURL
            self.description = description
            self.created = Formatter.iso8601.date(from: created as String)
            self.updated = Formatter.iso8601.date(from: updated as String)
            self.size = size
            self.language = language
            self.score = score
    }
  
}

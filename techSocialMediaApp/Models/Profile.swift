import Foundation

struct Profile: Codable {
    var firstName: String
    var lastName: String
    var userName: String
    var userUUID: UUID
    var bio: String
    var techInterests: String
    
    var posts: [Post]
}

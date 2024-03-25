import Foundation

struct Comment: Codable, Hashable {
    var commentId: Int
    var body: String
    var userName: String
    var userId: UUID
    var createdDate: String
}

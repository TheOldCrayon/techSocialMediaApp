
import Foundation

struct Post: Codable, Hashable {
    var postid: Int
    var title: String
    var body: String
    var authorUserName: String
    var likes: Int
    var userLiked: Bool
    var numComments: Int
    var createdDate: String
}

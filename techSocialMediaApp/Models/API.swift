//
//  API.swift
//  techSocialMediaApp
//
//  Created by Brayden Lemke on 10/25/22.
//

import Foundation

struct API {
    static var url = "https://tech-social-media-app.fly.dev"
    
    static let postsURl = URL(string: "https://tech-social-media-app.fly.dev/posts")
    static let profileURL = URL(string: "https://tech-social-media-app.fly.dev/userProfile")
    static let updateProfileURL = URL(string: "https://tech-social-media-app.fly.dev/updateProfile")
    static let createPostURL = URL(string: "https://tech-social-media-app.fly.dev/createPost")
    static let commentURL = URL(string: "https://tech-social-media-app.fly.dev/comments")
    static let deleteURL = URL(string: "https://tech-social-media-app.fly.dev/post")
    static let createCommentURL = URL(string: "https://tech-social-media-app.fly.dev/createComment")
    static let editPost = URL(string: "https://tech-social-media-app.fly.dev/editPost")
    static let userPostsURL = URL(string:"https://tech-social-media-app.fly.dev/userPosts")
}

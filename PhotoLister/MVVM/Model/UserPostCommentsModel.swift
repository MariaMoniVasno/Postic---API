//
//  UserPostCommentsModel.swift
//  PhotoLister
//
//  Created by Trident on 02/11/22.
//

import Foundation

// MARK: - UserPostComment
struct UserPostCommentsModel: Codable,Identifiable {
    let postID, id: Int
    let name, email, body: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case id, name, email, body
    }
}

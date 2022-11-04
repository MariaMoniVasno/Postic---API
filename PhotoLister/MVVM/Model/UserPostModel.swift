//
//  UserPostModel.swift
//  PhotoLister
//
//  Created by Trident on 02/11/22.
//

import Foundation

// MARK: - UserPostModel
struct UserPostModel: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}


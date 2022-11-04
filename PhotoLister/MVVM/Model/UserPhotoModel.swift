//
//  UserPhotoModel.swift
//  PhotoLister
//
//  Created by Trident on 02/11/22.
//

import Foundation

// MARK: - UserPhotoModel
struct UserPhotoModel: Codable {
    let albumID, id: Int
    let title: String
    let url, thumbnailURL: String?

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
}


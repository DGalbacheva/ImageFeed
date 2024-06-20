//
//  Photo.swift
//  ImageFeed
//
//  Created by Doroteya Galbacheva on 19.06.2024.
//

import UIKit

struct Photo {
    var id: String
    var size: CGSize
    let createdAt: Date?
    var welcomeDescription: String?
    var thumbImageURL: String
    var largeImageURL: String
    var isLiked: Bool
    let regularImageURL: String
}


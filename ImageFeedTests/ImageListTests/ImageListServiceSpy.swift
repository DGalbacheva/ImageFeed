//
//  ImageListServiceSpy.swift
//  ImageFeedTests
//
//  Created by Doroteya Galbacheva on 26.06.2024.
//

import ImageFeed
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

final class ImageListServiceSpy: ImagesListServiceProtocol {
    var photos: [Photo] = []
    
    func fetchPhotosNextPage() {
        let mockPhoto = Photo(id: "id",
                              size: CGSize(width: 1.0, height: 1.0),
                              createdAt: nil, thumbImageURL: "thumbImageURL",
                              largeImageURL: "largeImageURL",
                              isLiked: true,
                              regularImageURL: "regularImageURL")
        photos.append(mockPhoto)
    }
}

//
//  UrlsResult.swift
//  ImageFeed
//
//  Created by Doroteya Galbacheva on 19.06.2024.
//

import Foundation

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}


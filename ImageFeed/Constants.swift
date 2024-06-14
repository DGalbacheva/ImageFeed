//
//  Constants.swift
//  ImageFeed
//
//  Created by Doroteya Galbacheva on 07.05.2024.
//

import Foundation

enum Constants {
    static let accessKey = "3bgLDKhVjCDHoU7p63cw5c308kHEQGKFTuwIAkCoMJU"
    static let secretKey = "h4vDsNt8oNXzT-bucVoN8LUaQ0YF7R7lxXVewOrxAcA"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let grantType = "authorization_code"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
}

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
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    
    static let imageURL = "https://api.unsplash.com/photos?page="
    static let likeURL = "https://api.unsplash.com/photos/"
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: Constants.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.defaultBaseURL)
    }
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}

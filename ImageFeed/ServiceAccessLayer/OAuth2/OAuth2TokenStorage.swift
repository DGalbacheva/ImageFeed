//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Doroteya Galbacheva on 03.06.2024.
//

import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let tokenKey = "OAuth2AccessToken"
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
    func logout() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}

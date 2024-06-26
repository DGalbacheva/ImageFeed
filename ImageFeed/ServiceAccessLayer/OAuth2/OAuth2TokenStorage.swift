//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Doroteya Galbacheva on 03.06.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    let accessToken = "token"
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: accessToken)
        }
        set {
            guard let newValue else { return }
            KeychainWrapper.standard.set(newValue, forKey: accessToken)
        }
    }
    
    func newToken(token: String) {
        self.token = token
    }
    
    func cleanToken() {
        KeychainWrapper.standard.removeAllKeys()
        print("Token sucessfully removed")
    }
}


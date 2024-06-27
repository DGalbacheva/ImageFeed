//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Doroteya Galbacheva on 20.06.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    private let oauthTokenStorage = OAuth2TokenStorage()
    private let profileImageService = ProfileImageService.shared
    private let imageListService = ImagesListService.shared
    private let profileService = ProfileService.shared
  
   private init() { }

   func logout() {
       cleanCookies()
   }

   private func cleanCookies() {
      HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
      WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
         records.forEach { record in
            WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
         }
      }
       oauthTokenStorage.cleanToken()
       profileImageService.removeData()
       imageListService.removeData()
       profileService.removeData()
       
       guard let window = UIApplication.shared.windows.first else {
           assertionFailure("Error: invalid window configuration")
           return
       }
       window.rootViewController = SplashViewController()
   }
}
    

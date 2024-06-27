//
//  LogoutServiceSpy.swift
//  ImageFeedTests
//
//  Created by Doroteya Galbacheva on 26.06.2024.
//

import ImageFeed
import UIKit

final class ProfileLogoutServiceSpy: ProfileLogoutServiceProtocol {
    var logoutCalled: Bool = false

    func logout() {
        logoutCalled = true
    }
}

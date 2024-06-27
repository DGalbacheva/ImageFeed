//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Doroteya Galbacheva on 26.06.2024.
//

import ImageFeed
import UIKit

final class MockProfilePresenter: ProfilePresenterProtocol {
    var view: (any ImageFeed.ProfileViewControllerProtocol)?
    var viewDidLoadCalled: Bool = false
    let logoutService = ProfileLogoutServiceSpy()

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func updateAvatar() {
        guard let mockImage = UIImage(named: "11") else {return}
        view?.getNewAvatarValue(image: mockImage)
    }

    func logoutProfile() {
        logoutService.logout()
    }
}

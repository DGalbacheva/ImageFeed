//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Doroteya Galbacheva on 26.06.2024.
//

import UIKit
import Kingfisher

public protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateAvatar()
    func logoutProfile()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    weak var view: ProfileViewControllerProtocol?
    
    private let profileLogoutService = ProfileLogoutService.shared
    
    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
        installNewValueForLables()
    }
    
    private func installNewValueForLables() {
        guard let profile = ProfileService.shared.profile else {
            print("Profile not have value")
            return
        }
        view?.updateProfileDetails(name: profile.name, loginName: profile.loginName, bio: profile.bio)
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.profileImageURL,
            let imageUrl = URL(string: profileImageURL)
        else { return }
        print("Successfully fetched profile picture")
        KingfisherManager.shared.retrieveImage(with: imageUrl) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let retrieveImage):
                self.view?.getNewAvatarValue(image: retrieveImage.image)
            case .failure(let error):
                print("Ошибка при загрузке аватарки: \(error.localizedDescription)")
            }
        }
    }
    
    func logoutProfile() {
        profileLogoutService.logout()
    }
}

//
//  File.swift
//  ImageFeedTests
//
//  Created by Doroteya Galbacheva on 26.06.2024.
//

import ImageFeed
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var profileAvatar: UIImage?
    
    func updateProfileDetails(name: String, loginName: String, bio: String) {
        
    }
    
    func getNewAvatarValue(image: UIImage) {
        profileAvatar = image
    }
    
    func updateAvatar() {
        
    }
    
    func viewDidLoad() {
        presenter?.viewDidLoad()
    }
}

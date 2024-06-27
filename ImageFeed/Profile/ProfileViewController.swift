//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Doroteya Galbacheva on 11.04.2024.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateProfileDetails(name: String, loginName: String, bio: String)
    func getNewAvatarValue(image: UIImage)
    func updateAvatar()
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    var presenter: ProfilePresenterProtocol?
    
    private let storageToken = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    //private var profileImageServiceObserver: NSObjectProtocol?
    //private let profileLogoutService = ProfileLogoutService.shared
    
    //MARK: - UI elements
    private var imageView: UIImageView = {
        let avatarImage = UIImage(named: "avatar")
        let imageView = UIImageView(image: avatarImage)
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .ypWhite
        nameLabel.font = .boldSystemFont(ofSize: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private lazy var loginNameLabel: UILabel = {
        let loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = .ypGray
        loginNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return loginNameLabel
    }()
    
    private var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    private var logoutButton: UIButton = {
        let logoutButton = UIButton(type: .custom)
        logoutButton.setImage(UIImage(named: "logout_button"), for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        logoutButton.accessibilityIdentifier = "logout button"
        logoutButton.tintColor = .ypRed
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        return logoutButton
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        viewsSetting()
        applyConstrains()
        imageView.kf.indicatorType = .activity
        presenter?.viewDidLoad()
    }
    
    //MARK: - Private methods
    private func viewsSetting() {
        [imageView,
         nameLabel,
         loginNameLabel,
         descriptionLabel,
         logoutButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func applyConstrains() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func updateProfileDetails(name: String, loginName: String, bio: String) {
        nameLabel.text = name
        loginNameLabel.text = loginName
        descriptionLabel.text = bio
    }
    
    func updateAvatar() {
        presenter?.updateAvatar()
    }
    
    func getNewAvatarValue(image: UIImage) {
        imageView.image = image
    }
    
    @objc
    func logoutButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены что хотите выйти??", preferredStyle: .alert)
        let actionNo = UIAlertAction(title: "Нет", style: .cancel) { action in }
        let actionYes = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self = self else { return }
            //profileLogoutService.logout()
            presenter?.logoutProfile()
        }
        alert.addAction(actionNo)
        alert.addAction(actionYes)
        present(alert, animated: true)
        
    }
    
    func configureProfile(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
}

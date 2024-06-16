//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Doroteya Galbacheva on 03.06.2024.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oauth2TokenStorage.token {
            fetchProfile(token)
        } else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let authViewController = storyBoard.instantiateViewController(withIdentifier: "AuthViewController")
                    as? AuthViewController else { return }
            authViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: authViewController)
            navigationController.modalPresentationStyle = .fullScreen
            return present(navigationController, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }

    private func makeUI() {
        let splashScreenLogo = UIImageView()
        splashScreenLogo.image = UIImage(named: "splash_screen_logo")
        splashScreenLogo.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypBlack
        view.addSubview(splashScreenLogo)
        
        NSLayoutConstraint.activate([
            splashScreenLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashScreenLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        //print("didAuthenticate worked")
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                //self.fetchProfile(token)
                self.switchToTabBarController()
                //UIBlockingProgressHUD.dismiss()
                //print("Successfully fetched", token)
                //self.switchToTabBarController()
            case .failure(let error):
                //UIBlockingProgressHUD.dismiss()
                print("Failed to fetch", error)
                self.showAlert()
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token, completion:  { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                 //UIBlockingProgressHUD.dismiss()
                profileImageService.fetchProfileImageURL(token: token, username: profile.username) { _ in }
                //self.fetchProfileImage(token: token, username: profile.username)
                self.switchToTabBarController()
            case .failure(let error):
                //UIBlockingProgressHUD.dismiss()
                print("Error in parsing data: \(error.localizedDescription)")
                self.showAlert()
               // break
            }
        })
    }
    
    private func fetchProfileImage(token: String, username: String) {
        profileImageService.fetchProfileImageURL(token: token, username: username, { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print(error.localizedDescription)
                self.showAlert()
            }
        })
    }
}

extension SplashViewController {
    func showAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        self.present(alert, animated: true)
    }
}


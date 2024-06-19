//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Doroteya Galbacheva on 13.06.2024.
//

import Foundation

final class ProfileImageService {

    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    static let shared = ProfileImageService()
    private var task: URLSessionTask?
    private let token = OAuth2TokenStorage().token
    private var lastCode: String?
    private (set) var profileImageURL: String?
    
    private init(){}

    private enum NetworkError: Error {
        case codeError
        case invalidRequest
    }
    
    func makeHTTPRequest(token: String, username: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            print("Error creating URL for profile image request")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }

    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == token { return }
        task?.cancel()
        lastCode = token
        
        guard let request = makeHTTPRequest(token: token, username: username) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        let session = URLSession.shared
        let task = session.objectTask(for: request, completion: { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let imageURL):
                let profileImageURL = imageURL.profileImage.medium
                self.profileImageURL = profileImageURL
                completion(.success(profileImageURL))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": profileImageURL])
            case .failure(let error):
                print("Error fetching profile image: \(error.localizedDescription)")
                completion(.failure(error))
            }
        })
        self.task = task
        task.resume()
    }

    struct UserResult: Codable {
        let profileImage: ProfileImageURL

        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
    }

    struct ProfileImageURL: Codable {
        let small: String
        let medium: String
        let large: String
    }
}

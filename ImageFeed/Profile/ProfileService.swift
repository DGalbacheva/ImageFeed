//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Doroteya Galbacheva on 13.06.2024.
//

import Foundation

final class ProfileService {

    static let shared = ProfileService()
    private var task: URLSessionTask?
    private var lastCode: String?
    private (set) var profile: Profile?
    
    private init(){}

    private enum NetworkError: Error {
        case codeError
    }

    private func convertToProfile(_ ProfileResult: ProfileResult) -> Profile {
        return Profile(username: ProfileResult.userName, name: "\(ProfileResult.firstName) \(ProfileResult.lastName)", loginName: "@\(ProfileResult.userName)", bio: ProfileResult.bio ?? "")
         }

    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == token { return }
        task?.cancel()
        lastCode = token

        guard let request = makeRequest(token: token) else {
            print("Error in fetchProfile")
            return
        }
        let session = URLSession.shared
        let task = session.objectTask(for: request, completion: { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let currentUser):
                let newProfile = self.convertToProfile(currentUser)
                self.profile = newProfile
                completion(.success(newProfile))
            case .failure(let error):
                print("Error fetching profile: \(error.localizedDescription)")
                completion(.failure(error))
            }
        })
        self.task = task
        task.resume()
    }
    
    func removeData() {
        profile = nil
        lastCode = nil
        task = nil
    }

    struct ProfileResult: Codable {
        let userName, firstName, lastName: String
        let bio: String?

        enum CodingKeys: String, CodingKey {
            case userName = "username"
            case firstName = "first_name"
            case lastName = "last_name"
            case bio = "bio"
        }
    }

    struct Profile: Codable {
        let username, name, loginName: String
        let bio: String
    }
}

extension ProfileService {
    private func makeRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/" + "/me") else { 
            print("Error creating URL for profile request")
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

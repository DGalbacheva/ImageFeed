//
//  OAuth2.swift
//  ImageFeed
//
//  Created by Doroteya Galbacheva on 03.06.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private var lastCode: String?
    private var task: URLSessionTask?
    
    private (set) var authToken: String? {
            get {
                return OAuth2TokenStorage().token
            }
            set {
                guard let newValue = newValue else { return }
                OAuth2TokenStorage().token = newValue
            } }

    private init(){}
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        guard let request = authTokenRequest(code: code) else {
            print("Error creating URL request for OAuth token")
            completion(.failure(NetworkError.urlSessionError))
            return
        }
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                print("Error fetching OAuth token: \(error)")
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

extension OAuth2Service {
    
    private func authTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            print("Error creating base URL for OAuth token request")
            return nil
        }
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        )
        else {
            print("Error creating URL for OAuth token request")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    private struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
    }
    
    private func object(for request: URLRequest, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        return urlSession.objectTask(for: request, completion: { (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let body):
                completion(.success(body))
            case .failure(let error):
                print("Error fetching OAuth token response: \(error)")
                completion(.failure(error))
            }
        })
    }
}

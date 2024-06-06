//
//  OAuth2.swift
//  ImageFeed
//
//  Created by Doroteya Galbacheva on 03.06.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private var task: URLSessionTask?
    
    private init(){}
    
    private func oauthTokenRequest(code: String) -> URLRequest? {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: Constants.grantType)
        ]
        
        guard let urlRequest = urlComponents?.url else {
            print("URL")
            return nil
        }
        
        var request = URLRequest(url: urlRequest)
        request.httpMethod = "POST"
        
        return request
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = oauthTokenRequest(code: code) else {
            completion(.failure(NetworkError.urlSessionError))
            return
        }
        task = URLSession.shared.data(for: request) { result in
            switch result{
            case .success(let data):
                do {
                    let responseToken = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    OAuth2TokenStorage.shared.token = responseToken.accessToken
                    completion(.success(responseToken.accessToken))
                } catch {
                    completion(.failure(error))
                    print("Error decoding token response: ", error)
                }
            case .failure(let error):
                completion(.failure(error))
                print("Network error: ", error)
            }
        }
        task?.resume()
    }
}

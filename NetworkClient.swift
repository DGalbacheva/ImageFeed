//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Doroteya Galbacheva on 13.06.2024.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case error
}

/*extension URLRequest {
   static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: Constants.defaultBaseURL
    ) -> URLRequest {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
} */

extension URLSession {
    func objectTask<T: Decodable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                print("URLRequest error - \(error.localizedDescription)")
                fulfillCompletionOnMainThread(.failure(NetworkError.error))
                return
            }
        
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: data)
                        fulfillCompletionOnMainThread(.success(result))
                    } catch {
                        print("Eroor decoding response: \(error.localizedDescription)")
                        fulfillCompletionOnMainThread(.failure(error))
                    }
                } else {
                    print("Error: HTTP status code \(statusCode)")
                    fulfillCompletionOnMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error {
                print("Error creating URL request: \(error)")
                fulfillCompletionOnMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("Error: No data or response received")
                fulfillCompletionOnMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        return task
    }
}

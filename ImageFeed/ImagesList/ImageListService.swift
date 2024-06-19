//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Doroteya Galbacheva on 19.06.2024.
//

import UIKit

final class ImagesListService {
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    static let shared = ImagesListService()
    private var task: URLSessionTask?
    private (set) var photos: [Photo] = []
    private var lastLoadedPage = 1
    private let oAuthTokenStorage = OAuth2TokenStorage()
    private let session = URLSession.shared
    private let formatter = ISO8601DateFormatter()
    
    init(){}
    
    func fetchPhotosNextPage() {
        guard task == nil else { return }
        
        guard let request = makeHTTPPhotoRequest(page: lastLoadedPage) else { return }
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            self.task = nil
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                guard 200 ..< 300 ~= statusCode else {
                    let error = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    print("Error with HTTP statusCode: \(statusCode), message: \(error)")
                    return
                }
            }
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else {
                print("Error: Data could not be received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode([PhotoResult].self, from: data)
                DispatchQueue.main.async {
                    result.forEach {
                        self.photos.append(Photo(
                            id: $0.id,
                            size: CGSize(width: $0.width, height: $0.height),
                            createdAt: self.formattedDate($0.createdAt),
                            welcomeDescription: $0.description,
                            thumbImageURL: $0.urls.thumb,
                            fullImageURL: $0.urls.full,
                            isLiked: $0.likedByUser,
                            regularImageURL: $0.urls.regular)
                        )
                    }
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["photos": self.photos]
                    )
                    self.lastLoadedPage += 1
                }
            } catch {
                print("Error decoding photos: \(error)")
            }
        }
        task.resume()
    }
    
    func makeHTTPPhotoRequest(page: Int) -> URLRequest? {
        var components = URLComponents(string: "https://api.unsplash.com/photos")
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10"),
            URLQueryItem(name: "client_id", value: "UtikJ6aDHAwv8C_JVCEbQLQJ7ldEw_D3LVCSYvRfiyI")
        ]

        guard let url = components?.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
        
    }
    
    func formattedDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else {
            return nil
        }
        return formatter.date(from: dateString)
    }
    
    func convertPhotoResult(from photo: PhotoResult) -> Photo? {
        let date = formattedDate(photo.createdAt)
        
        return Photo(
            id: photo.id,
            size: CGSize(width: photo.width, height: photo.height),
            createdAt: date,
            welcomeDescription: photo.description,
            thumbImageURL: photo.urls.thumb,
            fullImageURL: photo.urls.full,
            isLiked: photo.likedByUser,
            regularImageURL: photo.urls.regular)
    }
}


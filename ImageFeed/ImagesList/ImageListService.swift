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
                            largeImageURL: $0.urls.full,
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
        guard let token = oAuthTokenStorage.token else {
            return nil
        }
        
        var components = URLComponents(string: "https://api.unsplash.com/photos")
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10"),
            URLQueryItem(name: "client_id", value: "UtikJ6aDHAwv8C_JVCEbQLQJ7ldEw_D3LVCSYvRfiyI")
        ]
        
        guard let url = components?.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
            largeImageURL: photo.urls.full,
            isLiked: photo.likedByUser,
            regularImageURL: photo.urls.regular)
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
       // var httpMethod: String
        
        guard let token = oAuthTokenStorage.token else { return }
        
        let likeUrl = Constants.likeURL + "\(photoId)/like"
        guard let url = URL(string: likeUrl) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "DELETE" : "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else {
                return
            }
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                guard 200 ..< 300 ~= statusCode else {
                    let errorMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    print("[objectTask]: HTTP error - status code \(statusCode), message: \(errorMessage)")
                    return
                }
            }
            if let error = error {
                print("Error fetching like: \(error)")
                return
            }
            if let index = self.photos.firstIndex(where: { $0.id == photoId}) {
                let photo = self.photos[index]
                let newPhoto = Photo(
                    id: photo.id,
                    size: photo.size,
                    createdAt: photo.createdAt,
                    thumbImageURL: photo.thumbImageURL,
                    largeImageURL: photo.largeImageURL,
                    isLiked: isLike,
                    regularImageURL: photo.regularImageURL)
                DispatchQueue.main.async {
                    self.photos[index] = newPhoto
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["photos": self.photos])
                    completion(.success(()))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(
                        domain: "Error: Photo not found",
                        code: 0,
                        userInfo: nil)))
                }
            }
        }
        task.resume()
    }
    
    func removeData() {
        task = nil
        photos = []
        lastLoadedPage = 1
    }
}

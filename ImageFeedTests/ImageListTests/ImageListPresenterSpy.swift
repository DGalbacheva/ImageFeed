//
//  ImageListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Doroteya Galbacheva on 26.06.2024.
//

import ImageFeed
import UIKit

final class ImageListPresenterSpy: ImageListPresenterProtocol {
    var photos: [ImageFeed.Photo] = []
    
    var view: (any ImageFeed.ImagesListViewControllerProtocol)?
    var imageListServiceObserver: NSObjectProtocol?
    var mockphotos: [Photo] = []
    var viewDidLoadCalled: Bool = false
    var imageListService: ImageListServiceSpy?
    var cellDidConfig: Bool = false
    
    func configCell(for cell: ImageFeed.ImagesListCell, with indexPath: IndexPath) {
        cellDidConfig = true
    }
    
    func updateTableView(tableView: UITableView) {
        
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func tableViewWillDisplay(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableViewHeightForRowAtIndexPath(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(10.0)
    }
    
    func imageListCellDidTapLike(_ cell: ImageFeed.ImagesListCell, tableView: UITableView) {
        
    }
    
    
}

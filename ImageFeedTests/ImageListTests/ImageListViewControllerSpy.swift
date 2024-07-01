//
//  ImageListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Doroteya Galbacheva on 26.06.2024.
//

import ImageFeed
import UIKit

final class ImagesListVCSpy: ImagesListViewControllerProtocol {
    var presenter: ImageListPresenterProtocol?

    func updateTableViewAnimated() {

    }

    func showErrorAlert(error: any Error) {

    }

    func viewDidLoad() {
        presenter?.viewDidLoad()
    }
}

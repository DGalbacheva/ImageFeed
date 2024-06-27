//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Doroteya Galbacheva on 01.04.2024.
//
import Foundation

import XCTest
@testable import ImageFeed

final class ImageFeedTests: XCTestCase {

    func testExapmle() {
        
    }

    func testFetchPhotos() {
        let service = ImagesListService()

        let expectation = self.expectation(description: "Wait for notification")

        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }

        service.fetchPhotosNextPage()
        wait(for: [expectation], timeout: 10)

        XCTAssertEqual(service.photos.count, 10)
    }
}

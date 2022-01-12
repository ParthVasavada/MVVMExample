//
//  ImageManagerTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Parth Vasavada on 01/05/21.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
@testable import CS_iOS_Assignment

class ImageManagerTests: XCTestCase {

    private var session: MockURLSession!
    
    private var services: MovieService!
    
    private var helper: Helper!
    
    private var manager: ImageManager!
    
    private let imageName = "Placeholder"
    
    private let expDescription = "Image manager test"
    
    override func setUp() {
        super.setUp()
        self.helper = Helper()
    }

    override func tearDownWithError() throws {
        self.session = nil
        self.services = nil
        self.manager = nil
        try super.tearDownWithError()
    }

    func testImageDownloading_Success() {
        self.session = MockURLSession(completionHandler: (UIImage(named: self.imageName)?.jpegData(compressionQuality: 1.0),nil, nil))
        self.services = MovieService(session: self.session)
        self.manager = ImageManager(services: self.services)
        
        let expectation = self.expectation(description: self.expDescription)
        
        self.manager.downloadImage(posterImagePath: "") { image in
            expectation.fulfill()
            XCTAssertNotNil(image)
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testImageDownloading_Error() {
        let customError = AppError.customError(description: "Invalid Response")
        self.session = self.helper.MockSession(fromJsonFile: "WrongFile", andError: customError)
        self.services = MovieService(session: self.session)
        self.manager = ImageManager(services: self.services)
        
        let expectation = self.expectation(description: self.expDescription)
        self.manager.downloadImage(posterImagePath: self.imageName) { image in
            expectation.fulfill()
            XCTAssertNil(image)
        }
        
        wait(for: [expectation], timeout: 3)
    }
      
    func testImageDownloading_ParsingError() {
        self.session = MockURLSession(completionHandler: (helper.invalidAPIKeyResponse.data(using: .utf8),nil, nil))
        self.services = MovieService(session: self.session)
        self.manager = ImageManager(services: self.services)
        let expectation = self.expectation(description: self.expDescription)
        self.manager.downloadImage(posterImagePath: self.imageName) { image in
            expectation.fulfill()
            XCTAssertNil(image)
        }
        
        wait(for: [expectation], timeout: 3)
    }

}

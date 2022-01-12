//
//  ImageDownloadServiceTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Parth Vasavada on 01/05/21.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
@testable import CS_iOS_Assignment

class ImageDownloadServiceTests: XCTestCase {

    private var session: MockURLSession!
    
    private var services: MovieService!
    
    private var helper: Helper!
    
    private let imageName = "Placeholder"
    
    private let expDescription = "Image Downloader Test"
    
    override func setUp() {
        super.setUp()
        self.helper = Helper()
    }

    override func tearDownWithError() throws {
        self.session = nil
        self.services = nil
        try super.tearDownWithError()
    }

    func testImageDownloading_Success() {
        self.session = MockURLSession(completionHandler: (UIImage(named: self.imageName)?.jpegData(compressionQuality: 1.0),nil, nil))
        self.services = MovieService(session: self.session)
        
        let expectation = self.expectation(description: self.expDescription)
        self.services.downloadMovieImage(url: URL(fileURLWithPath: helper.mockURL)) { response in
            expectation.fulfill()
            XCTAssertNotNil(response)
           
            guard case .success(let image) = response else {
                XCTFail()
                return
            }
            XCTAssertNotNil(image)
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testImageCaching_Sucess() {
        self.session = MockURLSession(completionHandler: (UIImage(named: self.imageName)?.jpegData(compressionQuality: 1.0),nil, nil))
        self.services = MovieService(session: self.session)
        
        let expectation = self.expectation(description: self.expDescription)
        self.services.downloadMovieImage(url: URL(fileURLWithPath: self.imageName)) { response in
            expectation.fulfill()
            XCTAssertNotNil(response)
            
            guard case .success(let image) = response,
                 let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
                XCTFail()
                return
            }
            XCTAssertNotNil(image)
            XCTAssertNotNil(appdelegate.imageCache.object(forKey: self.imageName as NSString))

        }
        wait(for: [expectation], timeout: 3)
    }
    
    func testImageDownloading_Error() {
        let customError = AppError.customError(description: "Invalid Response")
        self.session = self.helper.MockSession(fromJsonFile: "WrongFile", andError: customError)
        self.services = MovieService(session: self.session)
        
        let expectation = self.expectation(description: self.expDescription)
        self.services.downloadMovieImage(url: URL(fileURLWithPath: helper.mockURL)) { response in
            expectation.fulfill()
            XCTAssertNotNil(response)
            guard case .failure(let error) = response else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(error.localizedDescription, customError.localizedDescription)
        }
        
        wait(for: [expectation], timeout: 3)
    }
      
    func testImageDownloading_ParsingError() {
        let errorDescription =  "Unable to download Image."
        self.session = MockURLSession(completionHandler: (helper.invalidAPIKeyResponse.data(using: .utf8),nil, nil))
        self.services = MovieService(session: self.session)
        
        let expectation = self.expectation(description: self.expDescription)
        self.services.downloadMovieImage(url: URL(fileURLWithPath: helper.mockURL)) { response in
            expectation.fulfill()
            XCTAssertNotNil(response)
            guard case .failure(let error) = response,
                  case AppError.customError(let message) = error  else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(message, errorDescription)
        }
        
        wait(for: [expectation], timeout: 3)
    }

}

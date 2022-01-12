//
//  PopularMoviesServiceTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Parth Vasavada on 01/05/21.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
@testable import CS_iOS_Assignment

class PopularMoviesServiceTests: XCTestCase {
    
    private var session: MockURLSession!
    
    private var services: MovieService!
    
    private var helper: Helper!
    
    private let jsonFileName = "PopularMovies"
    
    private let expDescription = "Popular Movies Test"
    
    override func setUp() {
        super.setUp()
        self.helper = Helper()
    }

    override func tearDownWithError() throws {
        self.session = nil
        self.services = nil
        try super.tearDownWithError()
    }

    func testPopularMoviesService_Success() {
        self.session = self.helper.MockSession(fromJsonFile: self.jsonFileName)
        self.services = MovieService(session: self.session)
        
        let expectation = self.expectation(description: self.expDescription)
        self.services.fetchMovies(for: URL(fileURLWithPath: helper.mockURL)) { response in
            expectation.fulfill()
            XCTAssertNotNil(response)
            guard case .success(let result) = response else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(result.totalPages, 500)
            XCTAssertEqual(result.movies.count, 3)
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testPopularMoviesService_Success_ParseMovie() {
        self.session = self.helper.MockSession(fromJsonFile: self.jsonFileName)
        self.services = MovieService(session: self.session)
        
        let expectation = self.expectation(description: self.expDescription)
        self.services.fetchMovies(for: URL(fileURLWithPath: helper.mockURL)) { response in
            expectation.fulfill()
            XCTAssertNotNil(response)
            guard case .success(let result) = response,
                  let movie = result.movies.first else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(result.totalPages, 500)
            XCTAssertEqual(movie.title, "Mortal Kombat")
            XCTAssertEqual(movie.posterImagePath, "/6Wdl9N6dL0Hi0T1qJLWSz6gMLbd.jpg")
            XCTAssertEqual(movie.overview, "Washed-up MMA fighter Cole Young, unaware of his heritage, and hunted by Emperor Shang Tsung's best warrior, Sub-Zero, seeks out and trains with Earth's greatest champions as he prepares to stand against the enemies of Outworld in a high stakes battle for the universe.")
            XCTAssertEqual(movie.releaseDate, "2021-04-07")
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testPopularMoviesService_Error() {
        let customError = AppError.customError(description: "Invalid Response")
        self.session = self.helper.MockSession(fromJsonFile: "WrongFile", andError: customError)
        self.services = MovieService(session: self.session)
        
        let expectation = self.expectation(description: self.expDescription)
        self.services.fetchMovies(for: URL(fileURLWithPath: helper.mockURL)) { response in
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
      
    func testPolularMoviesService_ParsingError() {
        self.session = MockURLSession(completionHandler: (helper.invalidAPIKeyResponse.data(using: .utf8),nil, nil))
        self.services = MovieService(session: self.session)
        
        let expectation = self.expectation(description: self.expDescription)
        self.services.fetchMovies(for: URL(fileURLWithPath: helper.mockURL)) { response in
            expectation.fulfill()
            XCTAssertNotNil(response)
            guard case .failure(let error) = response else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(error, AppError.parsingError)
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
}

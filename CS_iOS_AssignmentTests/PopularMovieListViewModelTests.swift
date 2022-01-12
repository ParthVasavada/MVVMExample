//
//  PopularMovieListViewModelTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Parth Vasavada on 01/05/21.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
@testable import CS_iOS_Assignment
class PopularMovieListViewModelTests: XCTestCase {

    private var session: MockURLSession!
    
    private var services: MovieService!
    
    private var viewModel: PopularMovieListViewModel!
    
    private var helper: Helper!
    
    private let jsonFileName = "PopularMovies"
        
    private let expDescription = "Popular Movies List View Model Test"
    
    override func setUp() {
        super.setUp()
        self.helper = Helper()
    }

    override func tearDownWithError() throws {
        self.session = nil
        self.services = nil
        self.viewModel = nil
        try super.tearDownWithError()
    }
    
    func testGetPopularMoviesList_Success() {
        self.session = self.helper.MockSession(fromJsonFile: self.jsonFileName)
        self.services = MovieService(session: self.session)
        self.viewModel = PopularMovieListViewModel(self.services)
        
        let expectation = self.expectation(description: self.expDescription)
        
        self.viewModel.dataBinding = {
            expectation.fulfill()
            XCTAssertEqual(self.viewModel.movies.count, 3)
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testGetPopularMoviesList_Success_CheckProperties() {
        self.session = self.helper.MockSession(fromJsonFile: self.jsonFileName)
        self.services = MovieService(session: self.session)
        self.viewModel = PopularMovieListViewModel(self.services)
        
        let expectation = self.expectation(description: self.expDescription)
        
        self.viewModel.dataBinding = {
            expectation.fulfill()
            XCTAssertEqual(self.viewModel.movies.count, 3)
            
            guard let movie = self.viewModel.movies.first else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(movie.title, "Mortal Kombat")
            XCTAssertEqual(movie.posterImagePath, "/6Wdl9N6dL0Hi0T1qJLWSz6gMLbd.jpg")
            XCTAssertEqual(movie.overview, "Washed-up MMA fighter Cole Young, unaware of his heritage, and hunted by Emperor Shang Tsung's best warrior, Sub-Zero, seeks out and trains with Earth's greatest champions as he prepares to stand against the enemies of Outworld in a high stakes battle for the universe.")
            XCTAssertEqual(movie.releaseDate, "2021-04-07")
            
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testGetPopularMoviesList_UnSuccessfullScenario() {
        let customError = AppError.customError(description: "Invalid Response")
        self.session = self.helper.MockSession(fromJsonFile: "WrongFile", andError: customError)
        self.services = MovieService(session: self.session)
        self.viewModel = PopularMovieListViewModel(self.services)
        
        XCTAssertEqual(self.viewModel.movies.count, 0)
        XCTAssertNil(self.viewModel.dataBinding)

    }

}

//
//  MovieDetailViewModelTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Parth Vasavada on 01/05/21.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
@testable import CS_iOS_Assignment

class MovieDetailViewModelTests: XCTestCase {

    private var session: MockURLSession!
    
    private var services: MovieService!
    
    private var viewModel: MovieDetailViewModel!
    
    private var helper: Helper!
    
    private let selectedID = 460465
    
    private let jsonFileName = "MovieDetail"
        
    private let expDescription = "Movie detail view model Test"
    
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
    
    func testMovieDetail_Success() {
        self.session = self.helper.MockSession(fromJsonFile: self.jsonFileName)
        self.services = MovieService(session: self.session)
        self.viewModel = MovieDetailViewModel(selectedMovieId: self.selectedID, services: self.services)
        
        let expectation = self.expectation(description: self.expDescription)
        
        self.viewModel.dataBinding = { movieDetail in
            expectation.fulfill()
            XCTAssertNotNil(movieDetail)
        }
        XCTAssertNotNil(self.viewModel.dataBinding)
        wait(for: [expectation], timeout: 3)
    }
    
    func testGetMovieDetail_Success_CheckProperties() {
        self.session = self.helper.MockSession(fromJsonFile: self.jsonFileName)
        self.services = MovieService(session: self.session)
        self.viewModel = MovieDetailViewModel(selectedMovieId: self.selectedID, services: self.services)
        
        let expectation = self.expectation(description: self.expDescription)
        
        self.viewModel.dataBinding = { movieViewModel in
            expectation.fulfill()
            
            guard let title = movieViewModel.title,
                let overview = movieViewModel.overview,
                let releaseDateAndDuration = movieViewModel.movieDateAndDuration,
                let genres = movieViewModel.genres,
                let genre = genres.first else {
                XCTFail()
                return
            }

            XCTAssertEqual(title, "Mortal Kombat")
            XCTAssertEqual(genres.count, 5)
            XCTAssertEqual(genre.name, "Fantasy")
            XCTAssertEqual(overview, "Washed-up MMA fighter Cole Young, unaware of his heritage, and hunted by Emperor Shang Tsung's best warrior, Sub-Zero, seeks out and trains with Earth's greatest champions as he prepares to stand against the enemies of Outworld in a high stakes battle for the universe.")
            XCTAssertEqual(releaseDateAndDuration, "April 07, 2021 -  1h 50m")
        }
        XCTAssertNotNil(self.viewModel.dataBinding)
        wait(for: [expectation], timeout: 3)
    }
    
    func testMovieDetail_UnSuccessfullScenario() {
        let customError = AppError.customError(description: "Invalid Response")
        self.session = self.helper.MockSession(fromJsonFile: "WrongFile", andError: customError)
        self.services = MovieService(session: self.session)
        self.viewModel = MovieDetailViewModel(selectedMovieId: self.selectedID, services: self.services)
        
        XCTAssertNil(self.viewModel.dataBinding)

    }
}

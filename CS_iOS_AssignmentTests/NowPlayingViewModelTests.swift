//
//  NowPlayingViewModelTests.swift
//  CS_iOS_AssignmentTests
//
//  Created by Parth Vasavada on 02/05/21.
//  Copyright © 2021 Backbase. All rights reserved.
//

import XCTest
@testable import CS_iOS_Assignment

class NowPlayingViewModelTests: XCTestCase {

    private var session: MockURLSession!
    
    private var services: MovieService!
    
    private var viewModel: NowPlayingMovieListViewModel!
    
    private var helper: Helper!
    
    private let jsonFileName = "NowPlaying"
        
    private let expDescription = "Now playing Movies List View Model Test"
    
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
        self.viewModel = NowPlayingMovieListViewModel(self.services)
        
        let expectation = self.expectation(description: self.expDescription)
        
        self.viewModel.dataBinding = {
            expectation.fulfill()
            XCTAssertEqual(self.viewModel.nowPlayingMovies.count, 3)
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testGetPopularMoviesList_Success_CheckProperties() {
        self.session = self.helper.MockSession(fromJsonFile: self.jsonFileName)
        self.services = MovieService(session: self.session)
        self.viewModel = NowPlayingMovieListViewModel(self.services)
        
        let expectation = self.expectation(description: self.expDescription)
        
        self.viewModel.dataBinding = {
            expectation.fulfill()
            XCTAssertEqual(self.viewModel.nowPlayingMovies.count, 3)
            
            guard let movie = self.viewModel.nowPlayingMovies.first else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(movie.posterImagePath, "/pgqgaUx1cJb5oZQQ5v0tNARCeBp.jpg")
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testGetPopularMoviesList_UnSuccessfullScenario() {
        let customError = AppError.customError(description: "Invalid Response")
        self.session = self.helper.MockSession(fromJsonFile: "WrongFile", andError: customError)
        self.services = MovieService(session: self.session)
        self.viewModel = NowPlayingMovieListViewModel(self.services)
        
        XCTAssertEqual(self.viewModel.nowPlayingMovies.count, 0)
        XCTAssertNil(self.viewModel.dataBinding)

    }

}

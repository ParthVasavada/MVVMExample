//
//  PopularMovieListViewModel.swift
//  CS_iOS_Assignment
//
//  Created by Parth Vasavada on 27/04/21.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

class PopularMovieListViewModel: NSObject, DataBinding {
    
    var dataBinding: (() -> Void)?
    
    private let movieService: MovieService
    
    let imageManager = ImageManager()
    
    /// List of movies
    lazy var movies: [Movie] = [Movie]() {
        didSet {
            DispatchQueue.main.async {
                self.dataBinding?()
            }
        }
    }
    
    var currentPageNumber = 1 {
        didSet {
            guard let totalPages = self.totalPageCount,
                  self.currentPageNumber <= totalPages else { return }
            self.getPopularMoviesList()
        }
    }
    
    private var totalPageCount: Int?
    
    init(_ services: MovieService = MovieService()) {
        self.movieService = services
        super.init()
        self.getPopularMoviesList()
    }
    
    /// Fetches latest movie list from server.
    
    private func getPopularMoviesList() {
        
        let urlString = AppConstants.popularMoviesEndpoints + AppConstants.apiKey
            + AppConstants.languageParam + AppConstants.pageParam + "\(self.currentPageNumber)"
        guard let url = URL(string: urlString) else { return }
        
        movieService.fetchMovies(for: url) { result in
            
            switch result {
            
            case .success(let response):
                self.totalPageCount = response.totalPages
                if self.movies.isEmpty {
                    self.movies = response.movies
                } else {
                    self.movies.append(contentsOf: response.movies)
                }
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
}

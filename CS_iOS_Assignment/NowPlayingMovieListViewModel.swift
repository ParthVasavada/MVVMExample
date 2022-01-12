//
//  NowPlayingMovieListViewModel.swift
//  CS_iOS_Assignment
//
//  Created by Parth Vasavada on 29/04/21.
//  Copyright © 2021 Backbase. All rights reserved.
//
import UIKit
class NowPlayingMovieListViewModel: NSObject, DataBinding {
    
    let movieService: MovieService
    
    var dataBinding: (() -> Void)?
    
    let movieViewModel = ImageManager()
    
    var nowPlayingMovies = [Movie]() {
        didSet {
            DispatchQueue.main.async {
                self.dataBinding?()
            }
        }
    }
    
    init(_ services: MovieService = MovieService()) {
        self.movieService = services
        super.init()
        self.getNowPlayingMovieList()
    }
    
    private func getNowPlayingMovieList() {
        let urlString = AppConstants.nowPlayingMovieEndpoints + AppConstants.apiKey
            + AppConstants.languageParam + AppConstants.pageParam + "\(1)"
        guard let url = URL(string: urlString) else { return }
        
        movieService.fetchMovies(for: url) { result in
            
            switch result {
            
            case .success(let response):
                self.nowPlayingMovies = response.movies
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}



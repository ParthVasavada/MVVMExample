//
//  MovieDetailViewModel.swift
//  CS_iOS_Assignment
//
//  Created by Parth Vasavada on 29/04/21.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit

class MovieDetailViewModel: DataBinding {
    
    var dataBinding: ((MovieDetailViewModel) -> Void)?
    
    private let services: MovieService
    
    private var movieDetail: MovieDetails? {
        didSet {
            guard self.movieDetail != nil else { return }
            DispatchQueue.main.async {
                self.setupProperties()
                self.dataBinding?(self)
            }
        }
    }
    
    var movieDateAndDuration: String?
    
    var title: String?
    
    var overview: String?
    
    var genres: [Genre]?
    
    private let movieId: Int
    
    init(selectedMovieId: Int, services: MovieService = MovieService()) {
        self.movieId = selectedMovieId
        self.services = services
        self.fetchMovieDetail()
    }
    
    
    private func fetchMovieDetail() {
        
        let urlString = AppConstants.movieDetailsEndpoints + "/\(self.movieId)" + AppConstants.apiKey + AppConstants.languageParam
        guard let url = URL(string: urlString) else { return }
        MovieService().fetchMovieDetails(for: url) { result in
            switch result {
            case .success(let movieDetail):
                self.movieDetail = movieDetail
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func DateAndDuration() -> String? {
        guard let duration = self.movieDetail?.duration,
              let releaseDate =  self.convertReleaseDateToRequiredFormat() else { return nil }
        return "\(releaseDate) -  \(duration.hours)h \(duration.leftMinutes)m"
        
    }
    
    private func convertReleaseDateToRequiredFormat() -> String? {
        guard let releaseDate = self.movieDetail?.releaseDate else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let dateObj = dateFormatter.date(from: releaseDate) else { return nil}
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: dateObj)
    }
    
    private func setupProperties() {
        self.title = self.movieDetail?.title
        self.movieDateAndDuration = self.DateAndDuration()
        self.overview = self.movieDetail?.overview
        self.genres = self.movieDetail?.genres

    }
}

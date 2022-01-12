//
//  MovieCellViewModel.swift
//  CS_iOS_Assignment
//
//  Created by Parth Vasavada on 27/04/21.
//  Copyright © 2021 Backbase. All rights reserved.
//
import UIKit

struct ImageManager {
    
    private let movieServices: MovieService
    
    init(services: MovieService = MovieService()) {
        self.movieServices = services
    }
    
    func downloadImage(posterImagePath: String, complition: ((UIImage?) -> Void)?) {
        
        guard let url = URL(string: "\(AppConstants.Image.finalImageURL(size: .smallSize))\(posterImagePath)") else { return }
        self.movieServices.downloadMovieImage(url: url) { result in
            switch result {
            case .success(let image):
                complition?(image)
            case .failure(let error):
                complition?(nil)
                print(error.localizedDescription)
            }
        }
    }
}

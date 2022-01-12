//
//  AppConstants.swift
//  CS_iOS_Assignment
//
//  Created by Parth Vasavada on 27/04/21.
//  Copyright © 2021 Backbase. All rights reserved.
//

import Foundation

enum AppConstants {
    
    static let popularMoviesEndpoints = "https://api.themoviedb.org/3/movie/popular"
    
    static let nowPlayingMovieEndpoints = "https://api.themoviedb.org/3/movie/now_playing"
    
    static let apiKey = "?api_key=55957fcf3ba81b137f8fc01ac5a31fb5"
    
    static let languageParam = "&language=en-US"
    
    static let pageParam = "&page="
    
    static let movieDetailsEndpoints = "https://api.themoviedb.org/3/movie"
    
    static let movieIdKey = "{MOVIE_ID}"
    
    enum Image {
        
        static let endpoint = "https://image.tmdb.org/t/p/"
        
        case smallSize
        
        static func finalImageURL(size: Image) -> String {
            switch size {
            case .smallSize:
                return endpoint + "/w200"
            }
        }
    }
    
}

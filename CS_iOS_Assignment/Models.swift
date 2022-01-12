//
//  Models.swift
//  CS_iOS_Assignment
//
//  Created by Parth Vasavada on 27/04/21.
//  Copyright © 2021 Backbase. All rights reserved.
//

struct MovieDBResponse: Decodable {
    
    let movies: [Movie]
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
        case totalPages = "total_pages"
    }
}

struct Movie: Decodable {
    
    let id: Int
    let overview: String
    let releaseDate: String
    let title: String
    let posterImagePath: String
    let rating: Float
    
    enum CodingKeys: String, CodingKey {
        case id
        case overview
        case releaseDate = "release_date"
        case title
        case posterImagePath = "poster_path"
        case rating = "vote_average"
    }
    
}

struct MovieDetails: Decodable {
    
    let id: Double?
    let overview: String
    let releaseDate: String
    let title: String
    let posterImagePath: String
    let runtime: Int
    let genres: [Genre]
    
    enum CodingKeys: String, CodingKey {
        case id
        case overview
        case releaseDate = "release_date"
        case title
        case posterImagePath = "poster_path"
        case runtime
        case genres
    }
}

extension MovieDetails {
    var duration: (hours : Int , leftMinutes : Int) {
        return (self.runtime / 60, (self.runtime % 60))
    }
}

struct Genre: Decodable {
    let id: Double
    let name: String
}

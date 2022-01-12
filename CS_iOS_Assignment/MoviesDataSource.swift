//
//  MoviesDataSource.swift
//  CS_iOS_Assignment
//
//  Created by Parth Vasavada on 29/04/21.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit

extension PopularMovieListViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let movieCell:MovieCell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier,
                                                                      for: indexPath) as? MovieCell else {
            fatalError("Unable to dequeue cell")
        }
        
        let movie = self.movies[indexPath.row]
        
        movieCell.configure(title: movie.title,
                            date: movie.releaseDate,
                            rating: movie.rating)
        
        self.imageManager.downloadImage(posterImagePath: movie.posterImagePath) { image in
            DispatchQueue.main.async {
                movieCell.updateImage(image: image)
            }
        }
        
        return movieCell
    }
}

extension NowPlayingMovieListViewModel : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.nowPlayingMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            fatalError("Unable to deque Cell")
        }
        
        let movie = self.nowPlayingMovies[indexPath.row]
        
        self.movieViewModel.downloadImage(posterImagePath: movie.posterImagePath) { image in
            DispatchQueue.main.async {
                movieCell.updateMovieImage(image)
            }
        }
        
        return movieCell
    }
}

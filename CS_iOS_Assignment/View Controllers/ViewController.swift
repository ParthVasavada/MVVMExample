//
//  ViewController.swift
//  CS_iOS_Assignment
//
//  Copyright © 2019 Backbase. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let movieViewModel = PopularMovieListViewModel()
    let nowPlayingVieModel = NowPlayingMovieListViewModel()
    
    @IBOutlet private weak var moviesTableView: UITableView! {
        didSet {
            self.moviesTableView.dataSource = self.movieViewModel
        }
    }
    
    @IBOutlet weak var nowPlayingCollectionView: UICollectionView! {
        didSet {
            self.nowPlayingCollectionView.dataSource = self.nowPlayingVieModel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.systemYellow]
        
        self.movieViewModel.dataBinding = {
            self.moviesTableView.reloadData()
        }
        
        self.nowPlayingVieModel.dataBinding = {
            self.nowPlayingCollectionView.reloadData()
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let movieDetailVC = self.storyboard?.instantiateViewController(identifier: MovieDetailViewController.identifier) as? MovieDetailViewController,
              let cell = tableView.cellForRow(at: indexPath) as? MovieCell else { return }
        
        let selectedMovie = self.movieViewModel.movies[indexPath.row]
        
        let movieDetailVM = MovieDetailViewModel(selectedMovieId: selectedMovie.id)
        movieDetailVM.dataBinding = { movieViewModel in
            movieDetailVC.movieDetailsViewModel = movieViewModel
            movieDetailVC.posterImage = cell.posterImage
            self.present(movieDetailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 2 == self.movieViewModel.movies.count {
            self.movieViewModel.currentPageNumber += 1
        }
    }
}

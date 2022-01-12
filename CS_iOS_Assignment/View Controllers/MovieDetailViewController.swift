//
//  MovieDetailViewController.swift
//  CS_iOS_Assignment
//
//  Created by Parth Vasavada on 28/04/21.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    static let identifier = "MovieDetailViewController"
    
    @IBOutlet private weak var posterImageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var releaseDateLabel: UILabel!
    
    @IBOutlet private weak var overviewLabel: UILabel!
        
    var movieDetailsViewModel: MovieDetailViewModel?
    
    var posterImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.alpha = 0.85
        self.titleLabel.text = self.movieDetailsViewModel?.title
        self.overviewLabel.text = self.movieDetailsViewModel?.overview
        self.releaseDateLabel.text = self.movieDetailsViewModel?.movieDateAndDuration
        self.updatePosterImage()
    }
    
    func updatePosterImage() {
        self.posterImageView.image = self.posterImage
        self.view.layoutIfNeeded()
    }
    
    @IBAction func closeDetailsScreen(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension MovieDetailViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.movieDetailsViewModel?.genres?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let genreCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCell", for: indexPath) as? GenreCollectionViewCell else {
            fatalError("Unable to deque Cell")
        }
        
        let genre = self.movieDetailsViewModel?.genres?[indexPath.row]
        
        genreCell.genreLabel.text = genre?.name
        
        return genreCell
    }
    
}

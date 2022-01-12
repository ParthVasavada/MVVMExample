//
//  MovieCollectionViewCell.swift
//  CS_iOS_Assignment
//
//  Created by Parth Vasavada on 29/04/21.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionViewCell"

    @IBOutlet private weak var movieImageView: UIImageView!
        
    func updateMovieImage(_ image: UIImage?) {
        self.movieImageView.image = image
    }
    
}

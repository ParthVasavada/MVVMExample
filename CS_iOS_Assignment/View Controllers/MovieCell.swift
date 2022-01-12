//
//  MovieCell.swift
//  CS_iOS_Assignment
//
//  Copyright © 2019 Backbase. All rights reserved.
//

import UIKit

//
// MARK: - Movie Cell
//
class MovieCell: UITableViewCell {
    
    //
    // MARK: - Class Constants
    //
    static let identifier = "MovieCell"
    
    //
    // MARK: - IBOutlets
    //
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var rating: RatingView!
    @IBOutlet private weak var releaseDate: UILabel!
    @IBOutlet private weak var poster: UIImageView!
    
    var posterImage: UIImage? {
        return self.poster.image
    }
        
    func configure(title: String, date: String, rating: Float, image: UIImage? = nil) {
        self.title.text = title
        self.releaseDate.text = date
        self.rating.setValue(rating)
    }
    
    func updateImage(image: UIImage?) {
        self.poster.image = image
    }
}

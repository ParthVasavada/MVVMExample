//
//  GenreCollectionViewCell.swift
//  CS_iOS_Assignment
//
//  Created by Parth Vasavada on 02/05/21.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var genreLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
       
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = 2.0
    }
}

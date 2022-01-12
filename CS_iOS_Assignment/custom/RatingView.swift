//
//  RatingView.swift
//  CS_iOS_Assignment
//
//  Copyright © 2019 Backbase. All rights reserved.
//

import UIKit

class RatingView: UIView {
    
    @IBOutlet weak var ratingsLabel: UILabel!
    
    private let ratingCircleLayer = CAShapeLayer()
    private let fullCircleLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cleanup()
        self.setupRating()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.cleanup()
        self.setupRating()

    }
    
    private func cleanup() {
        self.ratingCircleLayer.removeFromSuperlayer()
        self.fullCircleLayer.removeFromSuperlayer()
    }
    
    private func setupRating() {
        self.backgroundColor = UIColor.black
        self.layer.cornerRadius = self.frame.size.width/2
        
        self.layoutIfNeeded()
        
        let centerPoint = CGPoint (x: self.bounds.width / 2, y: self.bounds.width / 2)
        let circleRadius : CGFloat = self.bounds.width / 2 * 0.83
        
        let circlePath =  UIBezierPath(arcCenter: centerPoint, radius: circleRadius, startAngle: CGFloat(-0.5 * Double.pi), endAngle: CGFloat(1.5 * Double.pi), clockwise: true    )
        
        // Adding full circle
        self.fullCircleLayer.path = circlePath.cgPath
        self.fullCircleLayer.lineCap = .round
        self.fullCircleLayer.strokeColor = UIColor.clear.cgColor
        self.fullCircleLayer.fillColor = UIColor.clear.cgColor
        self.fullCircleLayer.lineWidth = 3.0
        self.fullCircleLayer.strokeStart = 0
        self.fullCircleLayer.strokeEnd = 1.0
        self.layer.addSublayer(self.fullCircleLayer)
        
        // Adding rating circle
        self.ratingCircleLayer.path = circlePath.cgPath
        self.ratingCircleLayer.lineCap = .round
        self.ratingCircleLayer.strokeColor = UIColor.clear.cgColor
        self.ratingCircleLayer.fillColor = UIColor.clear.cgColor
        self.ratingCircleLayer.lineWidth = 3.0
        self.ratingCircleLayer.strokeStart = 0
        self.ratingCircleLayer.strokeEnd = 1.0
        self.layer.addSublayer(self.ratingCircleLayer)
    }
    
    func setValue(_ ratings: Float) {
        self.ratingCircleLayer.strokeEnd = CGFloat(ratings/10.0)
        let ratingToDisplay = Int(ratings*10)
        self.ratingsLabel.text = "\(ratingToDisplay)"
        self.ratingsLabel.textColor = .white
        self.ratingCircleLayer.strokeColor = ratingToDisplay > 50 ? UIColor.systemGreen.cgColor : UIColor.systemYellow.cgColor
        self.fullCircleLayer.strokeColor = ratingToDisplay > 50 ? UIColor.darkGreenRatingColor.cgColor : UIColor.yellowRatingColor.cgColor
    }
}

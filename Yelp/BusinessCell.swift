//
//  BusinessCell.swift
//  Yelp
//
//  Created by Steve Wan on 5/10/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbimageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var ratingimageView: UIImageView!
    
    @IBOutlet weak var reviewsCountLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var business: Business! {
        didSet { // whenever the business is set, want to view to reflect, therefore add the observer here
            nameLabel.text = business.name
            thumbimageView.setImageWithURL(business.imageURL)
            distanceLabel.text = business.distance
            ratingimageView.setImageWithURL(business.ratingImageURL)
            reviewsCountLabel.text = ("\(business.reviewCount!) reviews")
            addressLabel.text = business.address
            categoriesLabel.text = business.categories
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbimageView.layer.cornerRadius = 5
        thumbimageView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        println("call from awakeFromNib")
    }
    
    override func layoutSubviews() {// when rotates
        super.layoutSubviews() // each time when override parent, call itself again
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

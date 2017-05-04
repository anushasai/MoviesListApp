//
//  MoviesCustomTableViewCell.swift
//  Movies
//
//  Created by anusha rani on 5/4/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class MoviesCustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

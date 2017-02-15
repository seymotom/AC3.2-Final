//
//  MeatlyTableViewCell.swift
//  AC3.2-Final
//
//  Created by Tom Seymour on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class MeatlyTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var meatlyImageView: UIImageView!
    
    @IBOutlet weak var meatlyCommentLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

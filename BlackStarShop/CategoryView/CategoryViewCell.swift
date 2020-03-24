//
//  CategoryViewCell.swift
//  BlackStarShop
//
//  Created by Nikita Robertson on 24.03.2020.
//  Copyright © 2020 Nikita Robertson. All rights reserved.
//

import UIKit

class CategoryViewCell: UITableViewCell {
    
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        logoView.layer.cornerRadius = logoView.frame.width / 2.0
        logoView.layer.masksToBounds = true
        logoView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

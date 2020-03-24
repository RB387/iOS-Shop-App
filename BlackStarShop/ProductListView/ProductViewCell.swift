//
//  ProductViewCell.swift
//  BlackStarShop
//
//  Created by Nikita Robertson on 24.03.2020.
//  Copyright © 2020 Nikita Robertson. All rights reserved.
//

import UIKit

class ProductViewCell: UICollectionViewCell {
    
    @IBOutlet weak var priceView: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buyButton.layer.cornerRadius = buyButton.frame.width / 12
        buyButton.clipsToBounds = true
    }
    
}

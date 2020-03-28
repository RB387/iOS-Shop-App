//
//  ProductViewCell.swift
//  BlackStarShop
//
//  Created by Nikita Robertson on 24.03.2020.
//  Copyright © 2020 Nikita Robertson. All rights reserved.
//

import UIKit

protocol ProductViewCellDelegate: AnyObject {
    func buyButtonClicked(sender: ProductViewCell)
}

class ProductViewCell: UICollectionViewCell {
    
    @IBOutlet weak var priceView: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var productId: String?
    weak var delegate: ProductViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buyButton.layer.cornerRadius = buyButton.frame.width / 12
        buyButton.clipsToBounds = true
    }
    
    @IBAction func buyClick(_ sender: Any) {
        delegate?.buyButtonClicked(sender: self)
    }
    
}

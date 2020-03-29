//
//  CartTableViewCell.swift
//  BlackStarShop
//
//  Created by Nikita Robertson on 29.03.2020.
//  Copyright © 2020 Nikita Robertson. All rights reserved.
//

import UIKit

protocol CartCellDelegate: AnyObject {
    func deleteItem(at index: IndexPath?)
}

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var logoVIew: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    weak var delegate: CartCellDelegate?
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func deleteButtonClick(_ sender: Any) {
        delegate?.deleteItem(at: index)
    }
    
}

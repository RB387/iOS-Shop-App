//
//  ProductViewController.swift
//  BlackStarShop
//
//  Created by Nikita Robertson on 28.03.2020.
//  Copyright © 2020 Nikita Robertson. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    
    var productData: Product?
    
    @IBOutlet weak var gallery: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = productData?.name
        priceLabel.text = "\(productData?.price.split(separator: ".").first ?? "")Р"
        descriptionText.text = productData?.description
        buyButton.layer.cornerRadius = buyButton.frame.width / 16
        scrollView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GalleryViewController, segue.identifier == "showGallery" {
            vc.pictures = [productData!.mainImage] + productData!.productImages
        }
    }
    
    @IBAction func buyClick(_ sender: Any) {
        
    }
    
}

extension ProductViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 0 {
            gallery.bounds.origin.y = -scrollView.contentOffset.y
        }
    }
}

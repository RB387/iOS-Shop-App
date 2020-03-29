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
    let popUp = SizeWindowView()
    let shadow = UIView()
    let cellHeight: CGFloat = 90
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = productData?.name
        priceLabel.text = "\(productData?.price.split(separator: ".").first ?? "")Р"
        descriptionText.text = productData?.description
        buyButton.layer.cornerRadius = buyButton.frame.width / 16
        scrollView.delegate = self
        shadow.frame = view.bounds
        shadow.isHidden = true
        popUp.isHidden = true
        popUp.cellHeight = cellHeight
        popUp.data = productData
        popUp.delegate = self
        view.addSubview(shadow)
        view.addSubview(popUp)
        shadow.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        shadow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideMenu)))
        
        let rightButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(showCartClick))
        rightButton.image = #imageLiteral(resourceName: "shop")
        navigationItem.rightBarButtonItem = rightButton
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GalleryViewController, segue.identifier == "showGallery" {
            vc.pictures = [productData!.mainImage] + productData!.productImages
        }
    }
    
    @objc func hideMenu() {
        popUp.bounds.origin.y = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.popUp.frame = CGRect(x: 0, y: self.view.frame.height, width: self.popUp.frame.width, height: self.popUp.frame.height)
            self.shadow.alpha = 0
        }, completion: { complete in
            self.popUp.isHidden = true
            self.shadow.isHidden = true
        })
    }
    
    @IBAction func buyClick(_ sender: Any) {
        var height = cellHeight * CGFloat(productData!.offers.count)
        height = height < (scrollView.frame.height * 0.8) ? height : scrollView.frame.height * 0.8
        popUp.frame = CGRect(x: 0, y: view.frame.height - height, width: view.frame.width, height: height)
        popUp.bounds.origin.y = -height
        shadow.alpha = 0
        shadow.isHidden = false
        popUp.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.popUp.bounds.origin.y = 0
            self.shadow.alpha = 1
        })
    }
    @objc func showCartClick() {
        performSegue(withIdentifier: "showCart", sender: nil)
    }
}

extension ProductViewController: SizeWindowDelegate {
    func didSelectSize(product: Product, size: String) {
        var productDict = [String: String]()
        productDict["title"] = product.name
        productDict["size"] = size
        productDict["color"] = product.colorName
        productDict["price"] = product.price
        productDict["logo"] = product.mainImage
        productDict["id"] = product.id
        userDataOrders.append(productDict)
    }
    
    
}

extension ProductViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 0 {
            gallery.bounds.origin.y = -scrollView.contentOffset.y
        }
    }
}

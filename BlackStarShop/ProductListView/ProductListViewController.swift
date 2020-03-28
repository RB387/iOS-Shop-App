//
//  ProductListViewController.swift
//  BlackStarShop
//
//  Created by Nikita Robertson on 24.03.2020.
//  Copyright © 2020 Nikita Robertson. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var category: String?
    private let activity = UIActivityIndicatorView()
    private var productIds = [String]()
    private var products = [String: Product]()
    private var cachedImages = [String: UIImage]()
    private var serialQueue = DispatchQueue(label: "SerialQueue")
    private var model: ProductListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivity()
        activity.startAnimating()
        model = ProductListModel(category: category!)
        model!.fetchData({  [weak self] data in
            guard let self = self else { return }
            self.products = data
            self.productIds = Array<String>(data.keys)
            self.collectionView.reloadData()
            self.activity.stopAnimating()
        })
    }
    func setupActivity(){
        activity.center = view.center
        activity.hidesWhenStopped = true
        activity.style = .large
        view.addSubview(activity)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ProductViewController, let sender = sender as? ProductViewCell, segue.identifier == "showProductDetails" {
            vc.productData = products[sender.productId!]
        }
    }
}

extension ProductListViewController: ProductViewCellDelegate {
    func buyButtonClicked(sender: ProductViewCell) {
        performSegue(withIdentifier: "showProductDetails", sender: sender)
    }
}

extension ProductListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.size.width / 2 
        return CGSize(width: width - 8, height: width + width * 1/7 + 8 * 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductViewCell
        cell.imageView.image = nil
        cell.delegate = self
        cell.productId = productIds[indexPath.row]
        if let image = cachedImages[productIds[indexPath.row]]{
            cell.imageView.image = image
        } else {
            DispatchQueue.global(qos: .utility).async{ [weak self] in
                guard let self = self else { return }
                let url = URL(string: "https://blackstarwear.ru/\(self.products[self.productIds[indexPath.row]]!.mainImage)")
                if let data = try? Data(contentsOf: url!),
                let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                    self.serialQueue.sync {[weak self] in
                        guard let self = self else { return }
                        self.cachedImages[self.productIds[indexPath.row]] = image
                    }
                }
            }
        }
        let price = String(products[productIds[indexPath.row]]!.price.split(separator: ".").first ?? "")
        cell.priceView.text = "\(price)Р"
        return cell
    }
    
    
}

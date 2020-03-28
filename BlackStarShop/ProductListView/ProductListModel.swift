//
//  Model.swift
//  BlackStarShop
//
//  Created by Nikita Robertson on 24.03.2020.
//  Copyright © 2020 Nikita Robertson. All rights reserved.
//

import Foundation
import Alamofire

struct Product{
    var id: String
    var name: String
    var article: String
    var description: String
    var colorName: String
    var colorImageURL: String
    var mainImage: String
    var productImages: [String]
    var offers: [[String:String]]
    var recommendedProductIDs: [String]
    var price: String
    var attributes: [[String: String]]
}

class ProductListModel{
    
    var category: String
    
    init(category: String) {
        self.category = category
    }
    
    func fetchData(_ completion: @escaping (_ data: [String: Product]) -> ()){
        let url = "https://blackstarshop.ru/index.php?route=api/v1/products&cat_id=\(category)"
        AF.request(url).responseJSON(completionHandler: { response in
            var products = [String: Product]()
            if let data = response.value as? [String: [String: Any]]{
                for (key, product) in data{
                    if let name = product["name"] as? String,
                    let article = product["article"] as? String,
                    let description = product["description"] as? String,
                    let colorName = product["colorName"] as? String,
                    let colorImageURL = product["colorImageURL"] as? String,
                    let mainImage = product["mainImage"] as? String,
                    let productImages = product["productImages"] as? [[String: Any]],
                    let offers = product["offers"] as? [[String:String]],
                    let recommendedProductIDs = product["recommendedProductIDs"] as? [String],
                    let price = product["price"] as? String,
                    let attributes = product["attributes"] as? [[String:String]] {
                        var images = [String]()
                        for image in productImages {
                            if let imageUrl = image["imageURL"] as? String{
                                images.append(imageUrl)
                            }
                        }
                        products[key] = Product(id: key, name: name, article: article, description: description, colorName: colorName, colorImageURL: colorImageURL, mainImage: mainImage, productImages: images, offers: offers, recommendedProductIDs: recommendedProductIDs, price: price, attributes: attributes)
                    }
                }
            } else {
                print("CORRUPT")
            }
            DispatchQueue.main.async { completion(products) }
        })
    }
}

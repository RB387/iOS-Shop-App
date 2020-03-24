//
//  Model.swift
//  BlackStarShop
//
//  Created by Nikita Robertson on 24.03.2020.
//  Copyright © 2020 Nikita Robertson. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

struct Subcategory{
    var id: String
    var iconImage: String
    var name: String
    var type: String
}

struct Category{
    var id: String
    var image: String
    var name: String
    var iconImage: String
    var iconImageActive: String
    var subcategories: [Subcategory]
    
}

class CategoryModel {
    func fetchData(completion: @escaping (_ data: [Category]) -> ()){
        let url = "https://blackstarshop.ru/index.php?route=api/v1/categories"
        AF.request(url).responseJSON(completionHandler: { response in
            var categories = [Category]()
            if let data = response.value as? [String: [String: Any]] {
                for (key, category) in data {
                    if let name = category["name"] as? String,
                    let image = category["image"] as? String,
                    let iconImage = category["iconImage"] as? String,
                    let iconImageActive = category["iconImageActive"] as? String,
                    let subcategories = category["subcategories"] as? [[String:Any]] {
                        
                        if image == "" { continue }
                        
                        var subcategoryList = [Subcategory]()
                        for subcategory in subcategories{
                            var subcategoryElement = Subcategory(id: "None", iconImage: subcategory["iconImage"] as? String ?? "None", name: subcategory["name"] as? String ?? "None", type: subcategory["type"] as? String ?? "None")
                            if let id = subcategory["id"] as? String {
                                subcategoryElement.id = id
                            } else if let id = subcategory["id"] as? Int {
                                subcategoryElement.id = "\(id)"
                            }
                            subcategoryList.append(subcategoryElement)
                        }
                        
                        categories.append(Category(id: key, image: image, name: name, iconImage: iconImage, iconImageActive: iconImageActive, subcategories: subcategoryList))
                    }
                }
            }
            categories.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
            DispatchQueue.main.async {
                completion(categories)
            }
        })
    }
}

//
//  UserData.swift
//  BlackStarShop
//
//  Created by Nikita Robertson on 29.03.2020.
//  Copyright © 2020 Nikita Robertson. All rights reserved.
//

import Foundation

// MARK: - Keys of userDataOrders:
// MARK: - ["title", "size", "color", "price", "logo", "id"]

var userDataOrders: [[String: String]] {
    get {
        if let data = UserDefaults.standard.array(forKey: "UserData.orders") as? [[String: String]] {
            return data
        } else { return [] }
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "UserData.orders")
        UserDefaults.standard.synchronize()
    }
}

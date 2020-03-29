//
//  ShoppingCartViewController.swift
//  BlackStarShop
//
//  Created by Nikita Robertson on 29.03.2020.
//  Copyright © 2020 Nikita Robertson. All rights reserved.
//

import UIKit

class ShoppingCartViewController: UIViewController {

    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderButton: UIButton!
    var cachedImages = [String: UIImage]()
    var serialQueue = DispatchQueue(label: "cartSerialQueue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        totalPriceLabel.text = "\(getTotalPrice())Р"
    }
    deinit {
        print("----")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        orderButton.layer.cornerRadius = orderButton.frame.height / 2
    }
    
    func getTotalPrice() -> Float{
        var totalPrice: Float = 0
        for product in userDataOrders {
            totalPrice += Float(product["price"]!) ?? Float(0)
        }
        return totalPrice
    }
    
}

extension ShoppingCartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDataOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell") as! CartTableViewCell
        cell.logoVIew.image = nil
        cell.titleLabel.text = userDataOrders[indexPath.row]["title"]
        cell.colorLabel.text = userDataOrders[indexPath.row]["color"]
        cell.sizeLabel.text = "Размер: \(userDataOrders[indexPath.row]["size"] ?? "")"
        cell.delegate = self
        cell.index = indexPath
        cell.priceLabel.text = "\(userDataOrders[indexPath.row]["price"]?.split(separator: ".").first ?? "")Р"
        DispatchQueue.global(qos: .utility).async {
            if let image = self.cachedImages[userDataOrders[indexPath.row]["id"]!] {
                DispatchQueue.main.async {
                    cell.logoVIew.image = image
                }
            } else {
                let url =  URL(string: "https://blackstarwear.ru/\(userDataOrders[indexPath.row]["logo"] ?? "")")
                if let data = try? Data(contentsOf: url!), let image = UIImage(data: data) {
                    self.serialQueue.sync {
                        self.cachedImages[userDataOrders[indexPath.row]["id"]!] = image
                    }
                    DispatchQueue.main.async {
                        cell.logoVIew.image = image
                    }
                }
            }
        }
        return cell
    }
}

extension ShoppingCartViewController: CartCellDelegate {
    func deleteItem(at index: IndexPath?) {
        guard let index = index else { return }
        userDataOrders.remove(at: index.row)
        tableView.deleteRows(at: [index], with: .fade)
        totalPriceLabel.text = "\(getTotalPrice())Р"
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.3, execute: {
            self.tableView.reloadData()
        })
    }
}

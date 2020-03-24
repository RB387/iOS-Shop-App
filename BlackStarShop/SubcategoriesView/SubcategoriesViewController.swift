//
//  SubcategoriesViewController.swift
//  BlackStarShop
//
//  Created by Nikita Robertson on 24.03.2020.
//  Copyright © 2020 Nikita Robertson. All rights reserved.
//

import UIKit

class SubcategoriesViewController: UITableViewController {
    
    var subcategories: [Subcategory]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ProductListViewController,
            segue.identifier == "showProductsFromSubs", let sender = sender as? Subcategory{
            vc.category = sender.id
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subcategories!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = subcategories![indexPath.row].name
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showProductsFromSubs", sender: subcategories![indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }


}

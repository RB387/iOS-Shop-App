//
//  ViewController.swift
//  BlackStarShop
//
//  Created by Nikita Robertson on 17.03.2020.
//  Copyright © 2020 Nikita Robertson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let model = CategoryModel()
    private var categories = [Category]()
    private let activity = UIActivityIndicatorView()
    private var cachedImages = [String:UIImage]()
    private var serialQueue = DispatchQueue(label: "SerialQueue")
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivity()
        activity.startAnimating()
        
        model.fetchData(completion: { [weak self] data in
            guard let self = self else { return }
            self.categories = data
            self.tableView.reloadData()
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
        if let vc = segue.destination as? ProductListViewController, segue.identifier == "showProducts",
            let sender = sender as? Category{
            vc.category = sender.id
        } else if let vc = segue.destination as? SubcategoriesViewController, segue.identifier == "showSubs", let sender = sender as? Category {
            vc.subcategories = sender.subcategories
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryViewCell
        cell.logoView.image = nil
        cell.labelView.text = categories[indexPath.row].name
        if let image = cachedImages[categories[indexPath.row].id]{
            cell.logoView.image = image
        } else {
            DispatchQueue.global(qos: .utility).async { [weak self] in
                guard let self = self else { return }
                let url = URL(string: "https://blackstarwear.ru/\(self.categories[indexPath.row].image)")
                if let data = try? Data(contentsOf: url!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async { cell.logoView.image = image }
                        self.serialQueue.sync {[weak self] in
                            guard let self = self else { return }
                            self.cachedImages[self.categories[indexPath.row].id] = image
                        }
                    }
                }
            }
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categories[indexPath.row].subcategories.isEmpty{
            performSegue(withIdentifier: "showProducts", sender: categories[indexPath.row])
        } else {
            performSegue(withIdentifier: "showSubs", sender: categories[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


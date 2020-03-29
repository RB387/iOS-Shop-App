//
//  SizeWindowView.swift
//  BlackStarShop
//
//  Created by Nikita Robertson on 28.03.2020.
//  Copyright © 2020 Nikita Robertson. All rights reserved.
//

import UIKit

protocol SizeWindowDelegate: AnyObject {
    func didSelectSize(product: Product, size: String)
}

class SizeWindowView: UIView {
    
    var tableView = UITableView()
    var data: Product?
    var color: String = ""
    var cellHeight: CGFloat = 90
    weak var delegate: SizeWindowDelegate?
    private var newObject = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
        backgroundColor = .clear
        if !newObject { return }
        newObject = false
        configureSubviews()
    }
    
    func configureSubviews(){
        tableView.delegate =    self
        tableView.dataSource =  self
        tableView.backgroundColor = .white
        tableView.register(sizeTableCell.self, forCellReuseIdentifier: "sizeCell")
        addSubview(tableView)
    }
    

}

extension SizeWindowView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        data?.offers[indexPath.row]["checked"] = "true"
        (tableView.cellForRow(at: indexPath) as! sizeTableCell).checkLogo.isHidden = false
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectSize(product: data!, size: data?.offers[indexPath.row]["size"] ?? "")
    }
}

extension SizeWindowView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.offers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sizeCell") as! sizeTableCell
        if data?.offers[indexPath.row]["checked"] != nil { cell.checkLogo.isHidden = false }
        else { cell.checkLogo.isHidden = true }
        cell.colorLabel.text = data?.colorName
        cell.sizeEuLabel.text = "\(data?.offers[indexPath.row]["size"] ?? "") International"
        return cell
    }
    
}

class sizeTableCell: UITableViewCell {
    
    let generalStackView = UIStackView()
    let leftStackView = UIStackView()
    let rightStackView = UIStackView()
    let colorLabel = UILabel()
    let checkLogo = UIImageView()
    //let sizeRusLabel = UILabel()
    let sizeEuLabel = UILabel()
    
    func configureConstraints(){
        generalStackView.translatesAutoresizingMaskIntoConstraints =                                    false
        generalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive =               true
        generalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive =         true
        generalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8).isActive =     true
        generalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive =       true
        checkLogo.widthAnchor.constraint(equalTo: checkLogo.heightAnchor, multiplier: 0.3).isActive =   true
        checkLogo.topAnchor.constraint(equalTo: leftStackView.topAnchor).isActive =                     true
        checkLogo.bottomAnchor.constraint(equalTo: leftStackView.bottomAnchor).isActive =               true
        colorLabel.topAnchor.constraint(equalTo: leftStackView.topAnchor, constant: 0).isActive =       true
        colorLabel.bottomAnchor.constraint(equalTo: leftStackView.bottomAnchor, constant: 0).isActive = true
    }
    
    func configureSubviews() {
        //backgroundColor = .white
        addSubview(generalStackView)
        generalStackView.addArrangedSubview(leftStackView)
        generalStackView.addArrangedSubview(rightStackView)
        generalStackView.distribution = .fillEqually
        generalStackView.spacing = 8
        
        colorLabel.text = "Color"
        checkLogo.image = #imageLiteral(resourceName: "done")
        checkLogo.isHidden = true
        checkLogo.contentMode = .scaleAspectFit
        leftStackView.addArrangedSubview(colorLabel)
        leftStackView.addArrangedSubview(checkLogo)
        leftStackView.distribution = .fill
        leftStackView.alignment = .leading
        
        //sizeRusLabel.text = "39"
        sizeEuLabel.text = "S"
        //rightStackView.addArrangedSubview(sizeRusLabel)
        rightStackView.addArrangedSubview(sizeEuLabel)
        rightStackView.distribution = .fillEqually
        
        configureConstraints()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//
//  GalleryViewController.swift
//  BlackStarShop
//
//  Created by Nikita Robertson on 28.03.2020.
//  Copyright © 2020 Nikita Robertson. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    var pictures: [String]?
    
    @IBOutlet weak var scrollView: UIScrollView!
    var stackView = UIStackView()
    var imageView = UIImageView()
    var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(stackView)
        view.addSubview(pageControl)
        scrollView.delegate = self
        setupStackView()
        setupPageControl()
        scrollView.showsHorizontalScrollIndicator = false
        for url in pictures! {
            let image = setupImageView(imageUrl: url)
            stackView.addArrangedSubview(image)
            image.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
            image.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(pictures!.count), height: view.bounds.height)
    }
    
    func setupStackView(){
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
    }
    
    func setupPageControl(){
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        pageControl.currentPageIndicatorTintColor = .green
        pageControl.tintColor = .white
        pageControl.numberOfPages = pictures!.count
        pageControl.currentPage = 0
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 8).isActive = true
    }
    
    func setupImageView(imageUrl: String) -> UIImageView {
        let image = UIImageView()
        image.backgroundColor = .gray
        image.contentMode = .scaleAspectFill
        let url = URL(string: "https://blackstarwear.ru/\(imageUrl)")!
        DispatchQueue.global().async { [weak image] in
            guard let image = image else { return }
            if let data = try? Data(contentsOf: url), let imageLoaded = UIImage(data: data) {
                DispatchQueue.main.async {
                    image.image = imageLoaded
                }
            }
        }
        return image
    }
}

extension GalleryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = page
    }
}
